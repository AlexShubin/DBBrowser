//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StationSearchReducerTests: XCTestCase {

    func testSearchStringShouldSetSearchStringAndDisposeSearch() {
        let state = StationSearchState.applyEvents(initial: .initial, events: [
            .searchString("123"),
            .startSearch,
            .searchString("12345")
            ])
        XCTAssertEqual(state.searchString, "12345")
        XCTAssertFalse(state.shouldSearch)
    }

    func testStartSearch() {
        var state = StationSearchState.initial
        state = StationSearchState.reduce(state: state, event: .startSearch)
        XCTAssertTrue(state.shouldSearch)
    }

    func testMode() {
        var state = StationSearchState.initial
        state = StationSearchState.reduce(state: state, event: .mode(.corrStation))
        XCTAssertEqual(state.mode, .corrStation)
    }

    func testFound() {
        let expectedResult = StationFinderResult.success([StationBuilder().build()])
        var state = StationSearchState.initial
        state = StationSearchState.reduce(state: state, event: .found(expectedResult))
        XCTAssertFalse(state.shouldSearch)
        XCTAssertEqual(state.searchResult, expectedResult)
    }

    func testStationSelected() {
        // Prepare
        let expectedResult = [
            StationBuilder {
                $0.name = TestData.stationName1
                $0.evaId = TestData.stationId1
                }.build(),
            StationBuilder {
                $0.name = TestData.stationName2
                $0.evaId = TestData.stationId2
                }.build()
            ]
        // Run
        let state = StationSearchState.applyEvents(initial: .initial, events: [
            .found(.success(expectedResult)),
            .selected(1)
            ])
        // Test
        XCTAssertEqual(state.selectedStation, expectedResult[1])
    }

    func testClearEventSetsStateToInitial() {
        // Prepare
        let stations = [StationBuilder().build(),
                        StationBuilder().build()]
        // Run
        let state = StationSearchState.applyEvents(initial: .initial, events: [
            .found(.success(stations)),
            .selected(1),
            .clear
            ])
        // Test
        XCTAssertEqual(state, .initial)
    }
}
