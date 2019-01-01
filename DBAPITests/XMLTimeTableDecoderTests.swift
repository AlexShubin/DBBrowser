//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBAPI
import XCTest

//swiftlint:disable line_length
class XMLTimetableDecoderTests: XCTestCase {

    let decoder = XMLTimetablesDecoder()

    func testXMLTimetableDataParsedCorrectly() {
        guard let result = try? decoder.decodeTimetable(_testXMLTimetableData) else {
            XCTFail("String should be parsed")
            return
        }
        guard result.stops.count == 4 else {
            XCTFail("Timetable stops count should be 6")
            return
        }

        XCTAssertEqual(result.stops[0],
                       ApiStop(id: "4471729078023853954-1807071328-1",
                               tripLabel: ApiTripLabel(category: "ICE", number: "691"),
                               arrival: ApiEvent(platform: "18", time: "1807072130", path: "Berlin Hbf (tief)|Berlin Südkreuz|Lutherstadt Wittenberg Hbf|Leipzig Hbf|Erfurt Hbf|Eisenach|Fulda|Frankfurt(Main)Hbf|Mannheim Hbf|Stuttgart Hbf|Ulm Hbf|Augsburg Hbf|München-Pasing"),
                               departure: nil))

        XCTAssertEqual(result.stops[1].id, "3207621895872414763-1807072151-1")
        XCTAssertEqual(result.stops[1].tripLabel.category, "ICE")
        XCTAssertEqual(result.stops[1].tripLabel.number, "1718")
        XCTAssertEqual(result.stops[1].departure?.platform, "15")
        XCTAssertEqual(result.stops[1].departure?.time, "1807072151")
        XCTAssertEqual(result.stops[1].departure?.path, "Augsburg Hbf|Günzburg|Ulm Hbf|Stuttgart Hbf|Mannheim Hbf|Frankfurt(M) Flughafen Fernbf|Frankfurt(Main)Hbf|Eisenach|Gotha|Erfurt Hbf|Halle(Saale)Hbf|Bitterfeld|Berlin Südkreuz|Berlin Hbf (tief)")
        XCTAssertNil(result.stops[1].arrival)

        XCTAssertEqual(result.stops[2].id, "-381142949737100268-1807072144-1")
        XCTAssertEqual(result.stops[2].tripLabel.category, "RE")
        XCTAssertEqual(result.stops[2].tripLabel.number, "4868")
        XCTAssertEqual(result.stops[2].departure?.platform, "25")
        XCTAssertEqual(result.stops[2].departure?.time, "1807072144")
        XCTAssertEqual(result.stops[2].departure?.path, "Freising|Moosburg|Landshut(Bay)Hbf|Ergoldsbach|Neufahrn(Niederbay)|Eggmühl|Hagelstadt|Köfering|Obertraubling|Regensburg-Burgweinting|Regensburg Hbf")
        XCTAssertNil(result.stops[2].arrival)

        XCTAssertEqual(result.stops[3].id, "-1880473218992177718-1807072128-1")
        XCTAssertEqual(result.stops[3].tripLabel.category, "RB")
        XCTAssertEqual(result.stops[3].tripLabel.number, "27071")
        XCTAssertEqual(result.stops[3].departure?.platform, "14")
        XCTAssertEqual(result.stops[3].departure?.time, "1807072128")
        XCTAssertEqual(result.stops[3].departure?.path, "München Ost|Markt Schwaben|Hörlkofen|Walpertskirchen|Dorfen Bahnhof|Schwindegg|Ampfing|Mühldorf(Oberbay)")
        XCTAssertNil(result.stops[3].arrival)
    }

    private var _testXMLTimetableData: Data {
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

    func testXMLChangesDataParsedCorrectly() {
        guard let result = try? decoder.decodeChanges(_testXMLChangesData) else {
            XCTFail("String should be parsed")
            return
        }
        guard result.stops.count == 5 else {
            XCTFail("Timetable stops count should be 6")
            return
        }

        XCTAssertEqual(result.stops[0].id, "-690776802853422910-1808030629-1")
        XCTAssertEqual(result.stops[0].departure?.path, "München-Pasing|Augsburg Hbf|Stuttgart Hbf|Mannheim Hbf|Frankfurt(Main)Hbf|Fulda|Eisenach|Erfurt Hbf|Leipzig Hbf|Lutherstadt Wittenberg Hbf|Berlin Südkreuz")
        XCTAssertEqual(result.stops[0].departure?.time, "1808030630")
        XCTAssertNil(result.stops[0].departure?.status)
        XCTAssertNil(result.stops[0].departure?.platform)
        XCTAssertNil(result.stops[0].arrival)

        XCTAssertEqual(result.stops[1].id, "-5057048816279372783-1808031352-1")
        XCTAssertNil(result.stops[1].departure?.path)
        XCTAssertEqual(result.stops[1].departure?.time, "1808031359")
        XCTAssertNil(result.stops[1].departure?.status)
        XCTAssertNil(result.stops[1].departure?.platform)
        XCTAssertNil(result.stops[1].arrival)

        XCTAssertEqual(result.stops[2].id, "2118840296672669969-1808032329-1")
        XCTAssertNotNil(result.stops[2].departure)
        XCTAssertNil(result.stops[2].departure?.path)
        XCTAssertNil(result.stops[2].departure?.time)
        XCTAssertNil(result.stops[2].departure?.status)
        XCTAssertNil(result.stops[2].departure?.platform)
        XCTAssertNil(result.stops[2].arrival)

        XCTAssertEqual(result.stops[3].id, "7982362628419445796-1808031505-5")
        XCTAssertEqual(result.stops[3].arrival?.platform, "29")
        XCTAssertNil(result.stops[3].arrival?.time)
        XCTAssertNil(result.stops[3].arrival?.status)
        XCTAssertNil(result.stops[3].arrival?.path)
        XCTAssertNil(result.stops[3].departure)

        XCTAssertEqual(result.stops[4].id, "-7265364076564664702-1808032329-1")
        XCTAssertNil(result.stops[4].departure?.platform)
        XCTAssertNil(result.stops[4].departure?.time)
        XCTAssertEqual(result.stops[4].departure?.status, "c")
        XCTAssertEqual(result.stops[4].departure?.path, "")
        XCTAssertNil(result.stops[4].arrival)
    }

    private var _testXMLChangesData: Data {
        return """
        <timetable station="M&#252;nchen Hbf" eva="8000261">
            <s id="-690776802853422910-1808030629-1" eva="8000261">
                <m id="r61860s" t="r" from="1808030757" to="1808030913" ts="1808030913"/>
                <dp cpth="München-Pasing|Augsburg Hbf|Stuttgart Hbf|Mannheim Hbf|Frankfurt(Main)Hbf|Fulda|Eisenach|Erfurt Hbf|Leipzig Hbf|Lutherstadt Wittenberg Hbf|Berlin Südkreuz" ct="1808030630">
                    <m id="r35575746" t="f" c="0" ts="1808021454"/>
                    <m id="r35610298" t="q" c="80" ts="1808030652"/>
                </dp>
            </s>
            <s id="-5057048816279372783-1808031352-1" eva="8000261">
                <dp ct="1808031359"/>
            </s>
            <s id="2118840296672669969-1808032329-1" eva="8000261">
                <dp ppth="München-Pasing|Augsburg Hbf|Ansbach|Stuttgart Hbf" pp="15" pt="1808032329">
                    <m id="r35598806" t="f" c="0" ts="1808022156"/>
                    <m id="r35598815" t="f" c="0" ts="1808022157"/>
                    <m id="r35602314" t="q" c="86" ts="1808030153"/>
                    <m id="r35602640" t="f" c="0" ts="1808030311"/>
                </dp>
                <tl f="F" t="s" o="80" c="ICE" n="2508"/>
            </s>
            <s id="7982362628419445796-1808031505-5" eva="8000261">
                <ar cp="29"/>
            </s>
            <s id="-7265364076564664702-1808032329-1" eva="8000261">
                <dp cpth="" ppth="München-Pasing|Augsburg Hbf|Ansbach|Stuttgart Hbf" pp="15" pt="1808032329" cs="c" clt="1808022159">
                    <m id="r35598789" t="f" c="0" ts="1808022155"/>
                    <m id="r35598850" t="f" c="0" ts="1808022159"/>
                    <m id="r35598851" t="f" c="0" ts="1808022159"/>
                </dp>
                <tl f="F" t="s" o="80" c="ICE" n="1018"/>
            </s>
            <m id="i523686" t="u" from="1808011643" to="1808020340" ts="1808011643"/>
        </timetable>
        """.data(using: .utf8)!
    }

    func testXMLStationsDataParsedCorrectly() {
        let result = decoder.decodeStationInfo(_testXMLStationData)
        XCTAssertEqual(result, [ApiStationInfo(meta: "8070952|8071068|8089021|8098160")])
    }

    private var _testXMLStationData: Data {
        return """
        <stations>
            <station p="11|12 D - G|12|13 A - D|13|14|13 D - G|13 A - C|13 C - D|11 D - G|14 A - D|14 A - C|14 C - D|14 E - F|11 C - D|13 E - F|11 E - F|11 A - D|12 A - D|14 D - G|12 C - D|12 E - F" meta="8070952|8071068|8089021|8098160" name="Berlin Hbf" eva="8011160" ds100="BLS" db="true" creationts="18-08-02 16:20:18.519"/>
        </stations>
        """.data(using: .utf8)!
    }
}
