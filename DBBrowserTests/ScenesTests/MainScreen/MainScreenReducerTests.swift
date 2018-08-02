//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class MainScreenReducerTests: XCTestCase {

    func testDateEventSetsDate() {
        let date = Date.testSample(from: "10-10-2017 10:10")
        let state = MainScreenState.applyEvents(initial: .initial, events: [
                .date(date)
            ])
        XCTAssertEqual(state.date, date)
    }
    
    func testOpenTimetableEventSetShouldOpen() {
        let state = MainScreenState.applyEvents(initial: .initial, events: [
            .openTimetable
            ])
        XCTAssertTrue(state.shouldOpenTimetable)

    }

    func testTimetableOpenedEventSetShouldOpenToFalse() {
        let state = MainScreenState.applyEvents(initial: .initial, events: [
            .openTimetable,
            .timetableOpened
            ])
        XCTAssertFalse(state.shouldOpenTimetable)
        
    }
}

private extension Date {
    static func testSample(from str: String) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.CEST
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.date(from: str)!
    }
}
