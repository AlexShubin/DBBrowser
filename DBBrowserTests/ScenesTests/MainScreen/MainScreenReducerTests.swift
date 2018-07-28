//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class MainScreenReducerTests: XCTestCase {

    func testStationEventPutsStationIntoState() {
        let station = StationBuilder().build()
        let state = MainScreenState.applyEvents(initial: .initial, events: [
            .station(station)
            ])
        XCTAssertEqual(state.station, station)
    }
}
