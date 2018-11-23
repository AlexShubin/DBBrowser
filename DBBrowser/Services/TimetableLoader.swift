//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import DBAPI

protocol TimetableLoader {
    func load(evaId: Int, metaEvaIds: Set<Int>, date: Date, corrStation: Station?) -> Observable<Timetable>
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

    func load(evaId: Int, metaEvaIds: Set<Int>, date: Date, corrStation: Station?) -> Observable<Timetable> {
        let day = _dateFormatter.string(from: date, style: .apiTimetablesDate)
        let time = _dateFormatter.string(from: date, style: .apiTimetablesTime)
        var allIds = metaEvaIds
        allIds.insert(evaId)
        return _apiLoadTimetable(evaIds: allIds, date: day, hour: time).map {
            var timetable = self._timetableConverter.convert(from: $0)
            timetable.arrivals = self._applyFiltersAndSort(to: timetable.arrivals,
                                                           date: date,
                                                           corrStation: corrStation)
            timetable.departures = self._applyFiltersAndSort(to: timetable.departures,
                                                             date: date,
                                                             corrStation: corrStation)
            return timetable
        }
    }

    private func _apiLoadTimetable(evaIds: Set<Int>, date: String, hour: String) -> Observable<ApiTimetable> {
        return Observable.combineLatest(evaIds.map {
            self._timetableService.loadTimetable(evaNo: $0, date: date, hour: hour)
        }) { $0.reduce(ApiTimetable.empty, { $0 + $1 }) }
    }

    private func _applyFiltersAndSort(to events: [Timetable.Event],
                                      date: Date,
                                      corrStation: Station?) -> [Timetable.Event] {
        var result = events
            // dunno what they mean when the stations are empty. Let's filter these events out for now.
            .filter { !$0.stations.isEmpty }
            .trimOutdated(before: date)
            .sortedByTime
        if let corrStation = corrStation {
            result = result.filter {
                $0.stations.contains(where: { $0.interrelated(to: corrStation.name) })
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
