//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class DateTimeFormatterTests: XCTestCase {

    let formatter = AppDateTimeFormatter()

    func testTimetablesApiFormat() {
        let result = formatter.date(from: "1807072151", style: .timetablesApi)
        XCTAssertEqual(result, Date.testSample(from: "07-07-2018 21:51"))
    }

}

private extension Date {
    static func testSample(from str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.date(from: str)!
    }
}
