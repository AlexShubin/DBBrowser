//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift

typealias TimetableLoaderResult = Result<Timetable, TimetableLoaderError>

protocol TimetableLoader {
    func load(station: Station, dateTime: Date) -> Observable<TimetableLoaderResult>
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

    func load(station: Station, dateTime: Date) -> Observable<TimetableLoaderResult> {
        let date = _dateFormatter.string(from: dateTime, style: .ApiTimetablesDate)
        let time = _dateFormatter.string(from: dateTime, style: .ApiTimetablesTime)
        return _timetableService
            .loadTimetable(evaNo: String(station.evaId), date: date, hour: time)
            .map {
                .success(self._timetableConverter.convert(from: $0))
        }
            .catchError { _ in
                .just(.error(.unknown))
        }
    }
}
