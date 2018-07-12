//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableQueriesTests: XCTestCase {

    func testQueryLoadTimetable_returnsSearchParamsWhenShouldLoadAndParamsProvided() {
        let params = TimetableLoadParamsBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoadParams(params),
            .loadTimetable
            ])
        XCTAssertEqual(state.queryLoadTimetable, params)
    }

    func testQueryLoadTimetable_returnsNilWhenShouldLoadEventNotReceived() {
        let params = TimetableLoadParamsBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoadParams(params)
            ])
        XCTAssertNil(state.queryLoadTimetable)
    }
}
