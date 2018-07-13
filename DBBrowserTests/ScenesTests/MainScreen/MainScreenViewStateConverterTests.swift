//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class MainScreenViewStateConverterTests: XCTestCase {

    func testNoStationConverted() {
        // Prepare
        let state = MainScreenState.initial
        // Run
        let converted = MainScreenViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.station, .placeholder(L10n.MainScreen.stationPlaceholder))
    }

    func testChosenStationConverted() {
        // Prepare
        let station = StationBuilder()
            .with(name: TestData.stationName1)
            .build()
        let state = MainScreenState.applyEvents(initial: .initial, events: [
            .station(station)
            ])
        // Run
        let converted = MainScreenViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.station, .chosen(TestData.stationName1))
    }
}
