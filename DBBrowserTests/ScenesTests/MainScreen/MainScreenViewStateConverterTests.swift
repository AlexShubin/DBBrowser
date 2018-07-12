//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class MainScreenViewStateConverterTests: XCTestCase {

    func testNoStationConverted() {
        // Prepare
        let state = TimetableState.initial
        // Run
        let converted = MainScreenViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.departure, .placeholder(L10n.MainScreen.departurePlaceholder))
    }

    func testChosenStationConverted() {
        // Prepare
        let station = StationBuilder()
            .with(name: TestData.stationName1)
            .build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(station)
            ])
        // Run
        let converted = MainScreenViewStateConverter().convert(from: state)
        // Test
        XCTAssertEqual(converted.departure, .chosen(TestData.stationName1))
    }
}
