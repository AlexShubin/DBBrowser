//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableReducerTests: XCTestCase {

    func testInitial() {
        let state = TimetableState.initial
        XCTAssertNil(state.station)
        XCTAssertFalse(state.shouldLoadTimetable)
    }

    func testStationEventSetsStation() {
        let station = StationBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(station)
            ])
        XCTAssertEqual(state.station, station)
    }

    func testLoadTimetableEventShouldSetLoadFlag() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .loadTimetable
            ])
        XCTAssertEqual(state.shouldLoadTimetable, true)
    }

    func testTimetableLoadedEventShoudSetResultInState() {
        let timetableResult: TimetableLoaderResult = .success(TimetableBuilder().build())
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(timetableResult)
            ])
        XCTAssertEqual(state.timetableResult, timetableResult)
    }
}
