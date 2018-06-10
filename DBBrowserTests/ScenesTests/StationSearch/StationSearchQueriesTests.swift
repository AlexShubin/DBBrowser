//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StationSearchQueriesTests: XCTestCase {
    
    func testWhenActionSearch() {
        var state = StationSearchState.initial
        state.shouldSearch = "123"
        XCTAssertEqual(state.querySearch, "123")
    }
    
    func testWhenActionNil() {
        var state = StationSearchState.initial
        state.shouldSearch = nil
        XCTAssertNil(state.querySearch)
    }
}
