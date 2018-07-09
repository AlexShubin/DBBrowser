//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class MainScreenQueriesTests: XCTestCase {

    func testQueryOpenStaitonSearch_returnsNotNilWhenShouldOpenStationSearch() {
        var state = MainScreenState.initial
        state.shouldOpenStationSearch = true
        XCTAssertNotNil(state.queryOpenStationSearch)
    }

    func testQueryOpenStaitonSearch_returnsNilWhenShouldNotOpenStationSearch() {
        var state = MainScreenState.initial
        state.shouldOpenStationSearch = false
        XCTAssertNil(state.queryOpenStationSearch)
    }
}
