//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class MainScreenViewStateConverterTests: XCTestCase {

    func testNoStationConverted() {
        // Prepare
        var state = MainScreenState.initial
        state.departure = nil
        // Run
        let converted = MainScreenViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.departure, .placeholder(L10n.MainScreen.departurePlaceholder))
    }

    func testChosenStationConverted() {
        // Prepare
        let expectedStation = StationBuilder().build()
        var state = MainScreenState.initial
        state.departure = expectedStation
        // Run
        let converted = MainScreenViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.departure, .chosen(expectedStation.name))
    }
}
