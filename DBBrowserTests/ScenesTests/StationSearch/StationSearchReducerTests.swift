//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StationSearchReducerTests: XCTestCase {

    func testSearchString() {
        var state = StationSearchState.initial
        state = StationSearchState.reduce(state: state, event: .searchString("123"))
        XCTAssertEqual(state.searchString, "123")
    }

    func testStartSearch() {
        var state = StationSearchState.initial
        state = StationSearchState.reduce(state: state, event: .startSearch)
        XCTAssertTrue(state.shouldSearch)
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
            StationBuilder().with(evaId: TestData.stationId1).with(name: TestData.stationName1).build(),
            StationBuilder().with(evaId: TestData.stationId2).with(name: TestData.stationName2).build()
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
