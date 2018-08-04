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

    func testQueryStationSelected_returnsStationWhenStationSelectedAndModeIsStation() {
        let station = StationBuilder().build()
        let state = StationSearchState.applyEvents(initial: .initial, events: [
                .mode(.station),
                .searchString("123"),
                .startSearch,
                .found(.success([station])),
                .selected(0)
            ])
        XCTAssertEqual(state.querySelectedStation, .station(station))
    }

    func testQueryStationSelected_returnsCorrStationWhenStationSelectedAndModeIsCorrStation() {
        let station = StationBuilder().build()
        let state = StationSearchState.applyEvents(initial: .initial, events: [
            .mode(.corrStation),
            .searchString("123"),
            .startSearch,
            .found(.success([station])),
            .selected(0)
            ])
        XCTAssertEqual(state.querySelectedStation, .corrStation(station))
    }
}
