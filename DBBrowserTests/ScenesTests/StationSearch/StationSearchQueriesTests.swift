//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StationSearchQueriesTests: XCTestCase {

    func testQuerySearch_returnsSearchStringWhenShouldSearch() {
        var state = StationSearchState.initial
        state.searchString = "123"
        state.shouldSearch = true
        XCTAssertEqual(state.querySearch, "123")
    }

    func testQuerySearch_returnsNilWhenShouldNotSearch() {
        var state = StationSearchState.initial
        state.shouldSearch = false
        XCTAssertNil(state.querySearch)
    }

    func testQueryStationSelected_returnsStationWhenStationSelected() {
        var state = StationSearchState.initial
        state.selectedStation = StationBuilder().build()
        XCTAssertEqual(state.querySelectedStation, state.selectedStation)
    }

    func testQueryClose_returnsNotNilWhenShouldClose() {
        var state = StationSearchState.initial
        state.shouldClose = true
        XCTAssertNotNil(state.queryClose)
    }

    func testQueryClose_returnsNilWhenShouldNotClose() {
        var state = StationSearchState.initial
        state.shouldClose = false
        XCTAssertNil(state.queryClose)
    }
}
