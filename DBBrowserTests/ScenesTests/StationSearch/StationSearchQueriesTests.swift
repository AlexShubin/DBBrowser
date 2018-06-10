//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StationSearchQueriesTests: XCTestCase {
    
    func testWhenActionSearch() {
        var state = StationSearchState.initial
        state.searchString = "123"
        state.shouldSearch = true
        XCTAssertEqual(state.querySearch, "123")
    }
    
    func testWhenActionNil() {
        var state = StationSearchState.initial
        state.shouldSearch = false
        XCTAssertNil(state.querySearch)
    }
}
