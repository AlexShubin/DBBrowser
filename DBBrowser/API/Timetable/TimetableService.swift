//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import os.log

protocol TimetableService {
    func loadTimetable(evaNo: String, date: String, hour: String) -> Observable<ApiTimetable>
}

struct ApiTimetableService: TimetableService {

    private let _baseUrl: URL
    private let _urlSession: URLSession

    private let _decoder = XMLTimeTableDecoder()

    init(baseUrl: URL, configuration: URLSessionConfiguration) {
        _urlSession = URLSession(configuration: configuration)
        _baseUrl = baseUrl
    }

    func loadTimetable(evaNo: String, date: String, hour: String) -> Observable<ApiTimetable> {
        let request = URLRequest(url: _baseUrl.appendingPathComponent("/plan/\(evaNo)/\(date)/\(hour)"))
        return _urlSession.rx.data(request: request)
            .map {
                os_log("Response: %@", String(data: $0, encoding: .utf8) ?? "")
                return try self._decoder.decode($0)
        }
    }
}
