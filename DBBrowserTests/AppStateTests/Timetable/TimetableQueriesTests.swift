//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableQueriesTests: XCTestCase {

    func testQueryLoadTimetable_returnsSearchParamsWhenShouldLoadAndAllInfoProvided() {
        let station = StationBuilder().with(evaId: TestData.stationId1).build()
        let corrStation = StationBuilder().with(evaId: TestData.stationId2).build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(station),
            .corrStation(corrStation),
            .date(TestData.date1),
            .reset,
            .loadTimetable
            ])
        XCTAssertEqual(state.queryLoadTimetable, TimetableLoadParams(station: station,
                                                                     date: TestData.date1,
                                                                     corrStation: corrStation))
    }

    func testQueryLoadTimetable_returnsNilWhenShouldLoadEventNotReceived() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build())
            ])
        XCTAssertNil(state.queryLoadTimetable)
    }
}
