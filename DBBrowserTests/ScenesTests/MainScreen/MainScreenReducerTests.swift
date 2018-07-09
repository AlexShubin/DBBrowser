//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class MainScreenReducerTests: XCTestCase {

    func testInitial() {
        let state = MainScreenState.initial
        XCTAssertNil(state.departure)
        XCTAssertFalse(state.shouldOpenStationSearch)
    }

    func testSearchString() {
        // Prepare
        let expectedStation = StationBuilder().build()
        var state = MainScreenState.initial
        // Run
        state = MainScreenState.reduce(state: state, event: .departure(expectedStation))
        // Test
        XCTAssertEqual(state.departure, expectedStation)
    }

    func testShouldOpenStationSearch() {
        // Prepare
        var state = MainScreenState.initial
        // Run
        state = MainScreenState.reduce(state: state, event: .openStationSearch)
        // Test
        XCTAssertTrue(state.shouldOpenStationSearch)
    }

    func testStationSearchOpened() {
        // Prepare
        var state = MainScreenState.applyEvents(initial: .initial, events: [
            .openStationSearch,
            .stationSearchOpened
            ])
        // Run
        state = MainScreenState.reduce(state: state, event: .stationSearchOpened)
        // Test
        XCTAssertFalse(state.shouldOpenStationSearch)
    }
}
