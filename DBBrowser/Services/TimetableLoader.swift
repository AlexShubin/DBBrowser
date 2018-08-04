//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift

typealias TimetableLoaderResult = Result<Timetable, TimetableLoaderError>

protocol TimetableLoader {
    func load(with params: TimetableLoadParams) -> Observable<TimetableLoaderResult>
}

enum TimetableLoaderError: String, Error, Equatable {
    case unknown
}

struct ApiTimetableLoader: TimetableLoader {

    private let _timetableService: TimetablesService
    private let _timetableConverter: TimetableConverter
    private let _dateFormatter: DateTimeFormatter

    init(timetableService: TimetablesService,
         timetableConverter: TimetableConverter,
         dateFormatter: DateTimeFormatter) {
        _timetableService = timetableService
        _timetableConverter = timetableConverter
        _dateFormatter = dateFormatter
    }

    func load(with params: TimetableLoadParams) -> Observable<TimetableLoaderResult> {
        return Observable.combineLatest(
            _loadTimetable(station: params.station, date: params.date),
            _loadChanges(station: params.station)
        ) { (apiTimetable, apiChanges) in
            var timetable = self._timetableConverter.convert(from: apiTimetable, changes: apiChanges)
            timetable.arrivals = self._applyFiltersAndSort(to: timetable.arrivals, params: params)
            timetable.departures = self._applyFiltersAndSort(to: timetable.departures, params: params)
            return .success(timetable)
            }
            .catchError { _ in
                .just(.error(.unknown))
        }
    }

    private func _loadTimetable(station: Station, date: Date) -> Observable<ApiTimetable> {
        let evaId = String(station.evaId)
        let day = _dateFormatter.string(from: date, style: .apiTimetablesDate)
        let time = _dateFormatter.string(from: date, style: .apiTimetablesTime)
        if let additionalEvaId = station.additionalEvaId {
            return Observable.combineLatest(
                _timetableService.loadTimetable(evaNo: evaId, date: day, hour: time),
                _timetableService.loadTimetable(evaNo: String(additionalEvaId), date: day, hour: time)
            ) { $0 + $1 }
        } else {
            return _timetableService.loadTimetable(evaNo: evaId, date: day, hour: time)
        }
    }

    private func _loadChanges(station: Station) -> Observable<ApiChanges> {
        let evaId = String(station.evaId)
        if let additionalEvaId = station.additionalEvaId {
            return Observable.combineLatest(
                _timetableService.loadChanges(evaNo: evaId),
                _timetableService.loadChanges(evaNo: String(additionalEvaId))
            ) { $0 + $1 }
        } else {
            return _timetableService.loadChanges(evaNo: evaId)
        }
    }

    private func _applyFiltersAndSort(to events: [Timetable.Event],
                                      params: TimetableLoadParams) -> [Timetable.Event] {
        var result = events
            .trimOutdated(before: params.date)
            .sortedByTime
        if let corrStation = params.corrStation {
            result = result.filter {
                $0.stations.contains(where: { $0.contains(corrStation.name) || corrStation.name.contains($0) })
            }
        }
        return result
    }
}

private extension Array where Element == Timetable.Event {
    var sortedByTime: [Timetable.Event] {
        return sorted(by: { $0.time <= $1.time })
    }

    func trimOutdated(before date: Date) -> [Timetable.Event] {
        return filter { $0.time >= date }
    }
}
