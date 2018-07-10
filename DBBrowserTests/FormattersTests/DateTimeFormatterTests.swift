//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class DateTimeFormatterTests: XCTestCase {

    let formatter = AppDateTimeFormatter()

    func testTimetablesApiDateTime() {
        let result = formatter.date(from: "1807072151", style: .timetablesApiDateTime)
        XCTAssertEqual(result, Date.testSample(from: "07-07-2018 21:51"))
    }

    func testTimetablesApiDate() {
        let result = formatter.string(from: .testSample(from: "07-07-2018 21:51"),
                                      style: .timetablesApiDate)
        XCTAssertEqual(result, "180707")
    }
    
    func testTimetablesApiTime() {
        let result = formatter.string(from: .testSample(from: "07-07-2018 21:51"),
                                      style: .timetablesApiTime)
        XCTAssertEqual(result, "21")
    }
}

private extension Date {
    static func testSample(from str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.date(from: str)!
    }
}
