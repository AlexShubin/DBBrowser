//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift

typealias TimetableLoaderResult = Result<Timetable, TimetableLoaderError>

protocol TimetableLoader {
    func load(evaId: Int, date: Date, corrStation: Station?) -> Observable<TimetableLoaderResult>
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

    func load(evaId: Int, date: Date, corrStation: Station?) -> Observable<TimetableLoaderResult> {
        let day = _dateFormatter.string(from: date, style: .apiTimetablesDate)
        let time = _dateFormatter.string(from: date, style: .apiTimetablesTime)
        return _timetableService.loadTimetable(evaNo: evaId, date: day, hour: time).map {
            var timetable = self._timetableConverter.convert(from: $0)
            timetable.arrivals = self._applyFiltersAndSort(to: timetable.arrivals,
                                                           date: date,
                                                           corrStation: corrStation)
            timetable.departures = self._applyFiltersAndSort(to: timetable.departures,
                                                             date: date,
                                                             corrStation: corrStation)
            return .success(timetable)
            }
            .catchError { _ in
                .just(.error(.unknown))
        }
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
