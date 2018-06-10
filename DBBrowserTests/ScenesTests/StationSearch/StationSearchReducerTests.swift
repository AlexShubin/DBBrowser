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
        let someResult = StationFinderResult.success([StationBuilder().build()])
        var state = StationSearchState.initial
        state = StationSearchState.reduce(state: state, event: .found(someResult))
        XCTAssertFalse(state.shouldSearch)
        XCTAssertEqual(state.searchResult, someResult)
    }
}
