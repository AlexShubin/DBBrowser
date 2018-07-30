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

    private let _timetableService: TimetableService
    private let _timetableConverter: TimetableConverter
    private let _dateFormatter: DateTimeFormatter

    init(timetableService: TimetableService,
         timetableConverter: TimetableConverter,
         dateFormatter: DateTimeFormatter) {
        _timetableService = timetableService
        _timetableConverter = timetableConverter
        _dateFormatter = dateFormatter
    }

    func load(with params: TimetableLoadParams) -> Observable<TimetableLoaderResult> {
        let date = _dateFormatter.string(from: params.date, style: .apiTimetablesDate)
        let time = _dateFormatter.string(from: params.date, style: .apiTimetablesTime)
        return _timetableService
            .loadTimetable(evaNo: String(params.station.evaId), date: date, hour: time)
            .map {
                var timetable = self._timetableConverter.convert(from: $0)
                timetable.departures.sort(by: { $0.time <= $1.time })
                timetable.arrivals.sort(by: { $0.time <= $1.time })
                return .success(timetable)
            }
            .catchError { _ in
                .just(.error(.unknown))
        }
    }
}
