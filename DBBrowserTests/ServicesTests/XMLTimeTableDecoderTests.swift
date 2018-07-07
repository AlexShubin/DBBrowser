//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class XMLTimeTableDecoderTests: XCTestCase {
    
    let decoder = XMLTimeTableDecoder()
    
    func testXMLParsedCorrectly() {
        guard let result = decoder.decode(testXMLData) else {
            XCTFail("String should be parsed")
            return
        }
        guard result.count == 4 else {
            XCTFail("Timetable stops count should be 6")
            return
        }
        
        XCTAssertEqual(result[0].tl?.o, "80")
        XCTAssertEqual(result[0].tl?.c, "ICE")
        XCTAssertEqual(result[0].tl?.n, "691")
        XCTAssertEqual(result[0].ar?.pp, "18")
        XCTAssertEqual(result[0].ar?.pt, "1807072130")
        XCTAssertEqual(result[0].ar?.ppth, "Berlin Hbf (tief)|Berlin Südkreuz|Lutherstadt Wittenberg Hbf|Leipzig Hbf|Erfurt Hbf|Eisenach|Fulda|Frankfurt(Main)Hbf|Mannheim Hbf|Stuttgart Hbf|Ulm Hbf|Augsburg Hbf|München-Pasing")
        XCTAssertNil(result[0].dp)
        
        XCTAssertEqual(result[1].tl?.o, "80")
        XCTAssertEqual(result[1].tl?.c, "ICE")
        XCTAssertEqual(result[1].tl?.n, "1718")
        XCTAssertEqual(result[1].dp?.pp, "15")
        XCTAssertEqual(result[1].dp?.pt, "1807072151")
        XCTAssertEqual(result[1].dp?.ppth, "Augsburg Hbf|Günzburg|Ulm Hbf|Stuttgart Hbf|Mannheim Hbf|Frankfurt(M) Flughafen Fernbf|Frankfurt(Main)Hbf|Eisenach|Gotha|Erfurt Hbf|Halle(Saale)Hbf|Bitterfeld|Berlin Südkreuz|Berlin Hbf (tief)")
        XCTAssertNil(result[1].ar)
        
        XCTAssertEqual(result[2].tl?.o, "800746")
        XCTAssertEqual(result[2].tl?.c, "RE")
        XCTAssertEqual(result[2].tl?.n, "4868")
        XCTAssertEqual(result[2].dp?.pp, "25")
        XCTAssertEqual(result[2].dp?.pt, "1807072144")
        XCTAssertEqual(result[2].dp?.ppth, "Freising|Moosburg|Landshut(Bay)Hbf|Ergoldsbach|Neufahrn(Niederbay)|Eggmühl|Hagelstadt|Köfering|Obertraubling|Regensburg-Burgweinting|Regensburg Hbf")
        XCTAssertNil(result[2].ar)
        
        XCTAssertEqual(result[3].tl?.o, "8013D")
        XCTAssertEqual(result[3].tl?.c, "RB")
        XCTAssertEqual(result[3].tl?.n, "27071")
        XCTAssertEqual(result[3].dp?.pp, "14")
        XCTAssertEqual(result[3].dp?.pt, "1807072128")
        XCTAssertEqual(result[3].dp?.ppth, "München Ost|Markt Schwaben|Hörlkofen|Walpertskirchen|Dorfen Bahnhof|Schwindegg|Ampfing|Mühldorf(Oberbay)")
        XCTAssertNil(result[3].ar)
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



