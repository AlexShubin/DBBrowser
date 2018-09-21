//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxCocoa
import os.log

protocol TimetablesService {
    func loadTimetable(evaNo: Int, date: String, hour: String) -> Observable<ApiTimetable>
    func loadChanges(evaNo: Int) -> Observable<ApiChanges>
    func station(evaNo: Int) -> Observable<[ApiStationInfo]>
}

enum TimetablesServiceError: Error {
    case unknown
    /// Api throttling threshold crossed.
    case overwhelmed
}

/// Service duplicates API Timetables service. Returns plain models.
struct ApiTimetablesService: TimetablesService {

    private let _baseUrl: URL
    private let _urlSession: URLSession

    private let _decoder = XMLTimetablesDecoder()

    init(baseUrl: URL, configuration: URLSessionConfiguration) {
        _urlSession = URLSession(configuration: configuration)
        _baseUrl = baseUrl
    }

    /// This public interface allows access to information about a station.
    func station(evaNo: Int) -> Observable<[ApiStationInfo]> {
        return _makeRequest(with: "station/\(evaNo)", decoder: _decoder.decodeStationInfo)
    }

    /// Returns a Timetable object (see Timetable) that contains planned data
    /// for the specified station (evaNo) within the hourly time slice given by date (format YYMMDD)
    /// and hour (format HH). The data includes stops for all trips that arrive or depart within that slice.
    /// There is a small overlap between slices since some trips arrive in one slice and depart in another.
    ///
    /// Planned data does never contain messages. On event level, planned data contains the 'plannned'
    /// attributes pt, pp, ps and ppth while the 'changed' attributes ct, cp, cs and cpth are absent.
    ///
    /// Planned data is generated many hours in advance and is static, i.e. it does never change.
    /// It should be cached by web caches.public interface allows access to information about a station.
    func loadTimetable(evaNo: Int, date: String, hour: String) -> Observable<ApiTimetable> {
        return _makeRequest(with: "/plan/\(evaNo)/\(date)/\(hour)", decoder: _decoder.decodeTimetable)
    }

    /// Returns a Timetable object (see Timetable) that contains all known changes for the station
    /// given by evaNo.
    ///
    /// The data includes all known changes from now on until ndefinitely into the future.
    /// Once changes become obsolete (because their trip departs from the station) they are
    /// removed from this resource.
    ///
    /// Changes may include messages. On event level, they usually contain one or more of the 'changed'
    /// attributes ct, cp, cs or cpth. Changes may also include 'planned' attributes if there is no
    /// associated planned data for the change (e.g. an unplanned stop or trip).
    /// Full changes are updated every 30s and should be cached for that period by web caches.
    func loadChanges(evaNo: Int) -> Observable<ApiChanges> {
        return _makeRequest(with: "fchg/\(evaNo)", decoder: _decoder.decodeChanges)
    }

    private func _makeRequest<Decoded>(with pathComponent: String,
                                       decoder: @escaping (Data) throws -> Decoded) -> Observable<Decoded> {

        return _urlSession.rx.data(request: URLRequest(url: _baseUrl.appendingPathComponent(pathComponent)))
            .map {
                os_log("Response: %@", String(data: $0, encoding: .utf8) ?? "")
                return try decoder($0)
            }
            .catchError {
                if case .httpRequestFailed(let response, _)? = $0 as? RxCocoaURLError,
                    response.statusCode == 500 {
                    return .error(TimetablesServiceError.overwhelmed)
                }
                return .error(TimetablesServiceError.unknown)
        }
    }
}
