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
//swiftlint:disable force_try line_length line_length
    func loadTimetable(evaNo: String, date: String, hour: String) -> Observable<ApiTimetable> {
//        let request = URLRequest(url: _baseUrl.appendingPathComponent("/plan/\(evaNo)/\(date)/\(hour)"))
//        return _urlSession.rx.data(request: request)
//            .map {
//                os_log("Response: %@", String(data: $0, encoding: .utf8) ?? "")
//                return try self._decoder.decode($0)
//        }
        return .of(try! self._decoder.decode(testXMLData))
    }

    var testXMLData: Data {
        return """
        <timetable station='M&#252;nchen Hbf'>
          <s id="4471729078023853954-1807071328-14">
            <tl f="F" t="p" o="80" c="ICE" n="691"/>
            <ar pt="1807072130" pp="18" ppth="Berlin Hbf (tief)|Berlin S&#252;dkreuz|Lutherstadt Wittenberg Hbf|Leipzig Hbf|Erfurt Hbf|Eisenach|Fulda|Frankfurt(Main)Hbf|Mannheim Hbf|Stuttgart Hbf|Ulm Hbf|Augsburg Hbf|M&#252;nchen-Pasing"/>
          </s>
          <s id="3207621895872414763-1807072151-1">
            <tl f="F" t="p" o="80" c="ICE" n="1718"/>
            <dp pt="1807072151" pp="15" ppth="Augsburg Hbf|G&#252;nzburg|Ulm Hbf|Stuttgart Hbf|Mannheim Hbf|Frankfurt(M) Flughafen Fernbf|Frankfurt(Main)Hbf|Eisenach|Gotha|Erfurt Hbf|Halle(Saale)Hbf|Bitterfeld|Berlin S&#252;dkreuz|Berlin Hbf (tief)"/>
          </s>
          <s id="-381142949737100268-1807072144-1">
            <tl f="N" t="p" o="800746" c="RE" n="4868"/>
            <dp pt="1807072144" pp="25" ppth="Freising|Moosburg|Landshut(Bay)Hbf|Ergoldsbach|Neufahrn(Niederbay)|Eggm&#252;hl|Hagelstadt|K&#246;fering|Obertraubling|Regensburg-Burgweinting|Regensburg Hbf"/>
          </s>
          <s id="-1880473218992177718-1807072128-1">
            <tl f="N" t="p" o="8013D" c="RB" n="27071"/>
            <dp pt="1807072128" pp="14" pde="Burghausen" ppth="M&#252;nchen Ost|Markt Schwaben|H&#246;rlkofen|Walpertskirchen|Dorfen Bahnhof|Schwindegg|Ampfing|M&#252;hldorf(Oberbay)"/>
          </s>
        <\timetable>
        """.data(using: .utf8)!
    }
}
