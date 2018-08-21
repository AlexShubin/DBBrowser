//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StationSearchViewStateConverterTests: XCTestCase {

    func testLoadingConverted() {
        // Prepare
        var state = StationSearchState.initial
        state.searchString = "123"
        state.shouldSearch = true
        // Run
        let converted = StationSearchViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        XCTAssertEqual(converted.sections.first?.items.count, 1)
        XCTAssertEqual(converted.sections.first?.items.first, .loading)
    }

    func testErrorConverted() {
        // Prepare
        var state = StationSearchState.initial
        state.searchResult = .error(.unknown)
        // Run
        let converted = StationSearchViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        XCTAssertEqual(converted.sections.first?.items.count, 1)
        XCTAssertEqual(converted.sections.first?.items.first, .error)
    }

    func testLoadedConverted() {
        // Prepare
        let stations = [
            StationBuilder {
                $0.name = TestData.stationName1
                },
            StationBuilder {
                $0.name = TestData.stationName2
                }
            ].map { $0.build() }
        var state = StationSearchState.initial
        state.searchResult = .success(stations)
        // Run
        let converted = StationSearchViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        XCTAssertEqual(converted.sections.first?.items.count, 2)
        XCTAssertEqual(converted.sections.first?.items.first,
                       .station(StationCell.State(stationName: TestData.stationName1)))
        XCTAssertEqual(converted.sections.first?.items.last,
                       .station(StationCell.State(stationName: TestData.stationName2)))
    }
}
