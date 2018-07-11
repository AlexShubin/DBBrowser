//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

//swiftlint:disable line_length
class XMLTimeTableDecoderTests: XCTestCase {

    let decoder = XMLTimeTableDecoder()

    func testXMLParsedCorrectly() {
        guard let result = try? decoder.decode(testXMLData) else {
            XCTFail("String should be parsed")
            return
        }
        guard result.stops.count == 4 else {
            XCTFail("Timetable stops count should be 6")
            return
        }

        XCTAssertEqual(result.stops[0].tripLabel.category, "ICE")
        XCTAssertEqual(result.stops[0].tripLabel.number, "691")
        XCTAssertEqual(result.stops[0].arrival?.platform, "18")
        XCTAssertEqual(result.stops[0].arrival?.time, "1807072130")
        XCTAssertEqual(result.stops[0].arrival?.path, "Berlin Hbf (tief)|Berlin Südkreuz|Lutherstadt Wittenberg Hbf|Leipzig Hbf|Erfurt Hbf|Eisenach|Fulda|Frankfurt(Main)Hbf|Mannheim Hbf|Stuttgart Hbf|Ulm Hbf|Augsburg Hbf|München-Pasing")
        XCTAssertNil(result.stops[0].departure)

        XCTAssertEqual(result.stops[1].tripLabel.category, "ICE")
        XCTAssertEqual(result.stops[1].tripLabel.number, "1718")
        XCTAssertEqual(result.stops[1].departure?.platform, "15")
        XCTAssertEqual(result.stops[1].departure?.time, "1807072151")
        XCTAssertEqual(result.stops[1].departure?.path, "Augsburg Hbf|Günzburg|Ulm Hbf|Stuttgart Hbf|Mannheim Hbf|Frankfurt(M) Flughafen Fernbf|Frankfurt(Main)Hbf|Eisenach|Gotha|Erfurt Hbf|Halle(Saale)Hbf|Bitterfeld|Berlin Südkreuz|Berlin Hbf (tief)")
        XCTAssertNil(result.stops[1].arrival)

        XCTAssertEqual(result.stops[2].tripLabel.category, "RE")
        XCTAssertEqual(result.stops[2].tripLabel.number, "4868")
        XCTAssertEqual(result.stops[2].departure?.platform, "25")
        XCTAssertEqual(result.stops[2].departure?.time, "1807072144")
        XCTAssertEqual(result.stops[2].departure?.path, "Freising|Moosburg|Landshut(Bay)Hbf|Ergoldsbach|Neufahrn(Niederbay)|Eggmühl|Hagelstadt|Köfering|Obertraubling|Regensburg-Burgweinting|Regensburg Hbf")
        XCTAssertNil(result.stops[2].arrival)

        XCTAssertEqual(result.stops[3].tripLabel.category, "RB")
        XCTAssertEqual(result.stops[3].tripLabel.number, "27071")
        XCTAssertEqual(result.stops[3].departure?.platform, "14")
        XCTAssertEqual(result.stops[3].departure?.time, "1807072128")
        XCTAssertEqual(result.stops[3].departure?.path, "München Ost|Markt Schwaben|Hörlkofen|Walpertskirchen|Dorfen Bahnhof|Schwindegg|Ampfing|Mühldorf(Oberbay)")
        XCTAssertNil(result.stops[3].arrival)
    }

}

extension XMLTimeTableDecoderTests {
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
