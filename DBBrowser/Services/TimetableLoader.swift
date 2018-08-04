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
        let evaNo = String(params.station.evaId)
        let date = _dateFormatter.string(from: params.date, style: .apiTimetablesDate)
        let time = _dateFormatter.string(from: params.date, style: .apiTimetablesTime)
        return Observable.combineLatest(
            _timetableService.loadTimetable(evaNo: evaNo, date: date, hour: time),
            _timetableService.loadChanges(evaNo: evaNo)
        ) { (apiTimetable, apiChanges) in
            var timetable = self._timetableConverter.convert(from: apiTimetable, changes: apiChanges)
            timetable.arrivals = timetable.arrivals.trimOutdated(before: params.date).sortedByTime
            timetable.departures = timetable.departures.trimOutdated(before: params.date).sortedByTime
            return .success(timetable)
            }
            .catchError { _ in
                .just(.error(.unknown))
        }
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
