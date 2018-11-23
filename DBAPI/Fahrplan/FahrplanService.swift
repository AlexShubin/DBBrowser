//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import os.log

/// Service duplicates API Fahrplan service. Returns plain models.
public protocol FahrplanService {
    func searchStation(namePart: String) -> Observable<[FahrplanStation]>
}

public struct ApiFahrplanService: FahrplanService {

    private let _baseUrl: URL
    private let _urlSession: URLSession

    private let _decoder = JSONDecoder()

    public init(baseUrl: URL, configuration: URLSessionConfiguration) {
        _urlSession = URLSession(configuration: configuration)
        _baseUrl = baseUrl
    }

    /// Get information about locations matching the given name or name fragment.
    public func searchStation(namePart: String) -> Observable<[FahrplanStation]> {
        let request = URLRequest(url: _baseUrl.appendingPathComponent("/location/\(namePart)"))
        return _urlSession.rx.data(request: request)
            .map {
                os_log("Response: %@", String(data: $0, encoding: .utf8) ?? "")
                return try self._decoder.decode([FahrplanStation].self, from: $0)
        }
    }
}
