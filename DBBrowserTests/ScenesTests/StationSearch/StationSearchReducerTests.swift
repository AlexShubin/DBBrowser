//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StationSearchReducerTests: XCTestCase {
    
    func testSearch() {
        var state = StationSearchState.initial
        state = StationSearchState.reduce(state: state, event: .search("123"))
        XCTAssertEqual(state.shouldSearch, "123")
    }
    
    func testFound() {
        let someResult = StationFinderResult.success([StationBuilder().build()])
        var state = StationSearchState.initial
        state = StationSearchState.reduce(state: state, event: .found(someResult))
        XCTAssertNil(state.shouldSearch)
        XCTAssertEqual(state.searchResult, someResult)
    }
}
