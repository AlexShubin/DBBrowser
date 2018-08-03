//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableQueriesTests: XCTestCase {

    func testQueryLoadTimetable_returnsSearchParamsWhenShouldLoadAndAllInfoProvided() {
        let station = StationBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(station),
            .loadTimetable
            ])
        XCTAssertEqual(state.queryLoadTimetable?.station, station)
    }

    func testQueryLoadTimetable_returnsNilWhenShouldLoadEventNotReceived() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build())
            ])
        XCTAssertNil(state.queryLoadTimetable)
    }
}
