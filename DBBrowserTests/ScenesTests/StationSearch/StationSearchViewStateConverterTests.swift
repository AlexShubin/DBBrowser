//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StationSearchViewStateConverterTests: XCTestCase {
    
    func testLoadingConverted() {
        // Prepare
        var state = StationSearchState.initial
        state.stationSearch = .loading
        // Run
        let converted = StationSearchViewStateConverter().convert(state: state)
        // Test
        XCTAssertEqual(converted, .loading)
    }
    
    func testErrorConverted() {
        // Prepare
        var state = StationSearchState.initial
        state.stationSearch = .loaded(.error(.unknown))
        // Run
        let converted = StationSearchViewStateConverter().convert(state: state)
        // Test
        XCTAssertEqual(converted, .error)
    }
    
    func testLoadedConverted() {
        // Prepare
        let stations = [
            StationBuilder().with(name: TestData.stationName1),
            StationBuilder().with(name: TestData.stationName2)
            ].map { $0.build() }
        var state = StationSearchState.initial
        state.stationSearch = .loaded(.success(stations))
        // Run
        let converted = StationSearchViewStateConverter().convert(state: state)
        // Test
        guard case .stations(let sections) = converted else {
            XCTFail("Unexpected state")
            return
        }
        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections.first?.items.count, 2)
        XCTAssertEqual(sections.first?.items.first?.stationName, TestData.stationName1)
        XCTAssertEqual(sections.first?.items.last?.stationName, TestData.stationName2)
    }
}
