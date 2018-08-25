//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import os.log

protocol TimetablesService {
    func loadTimetable(evaNo: Int, date: String, hour: String) -> Observable<ApiTimetable>
    func loadChanges(evaNo: Int) -> Observable<ApiChanges>
    func station(evaNo: Int) -> Observable<[ApiStationInfo]>
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
        let request = URLRequest(url: _baseUrl.appendingPathComponent("station/\(evaNo)"))
        return _urlSession.rx.data(request: request)
            .map {
                os_log("Response: %@", String(data: $0, encoding: .utf8) ?? "")
                return self._decoder.decodeStationInfo($0)
        }
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
        let request = URLRequest(url: _baseUrl.appendingPathComponent("/plan/\(evaNo)/\(date)/\(hour)"))
        return _urlSession.rx.data(request: request)
            .map {
                os_log("Response: %@", String(data: $0, encoding: .utf8) ?? "")
                return try self._decoder.decodeTimetable($0)
        }
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
        let request = URLRequest(url: _baseUrl.appendingPathComponent("fchg/\(evaNo)"))
        return _urlSession.rx.data(request: request)
            .map {
                os_log("Response: %@", String(data: $0, encoding: .utf8) ?? "")
                return try self._decoder.decodeChanges($0)
        }
    }
}
