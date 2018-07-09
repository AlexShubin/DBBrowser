//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import XCTest
import RxSwift
@testable import DBBrowser
import RxTest

class StationFinderTests: XCTestCase {

    let fahrplanServiceMock = FahrplanServiceMock()
    var stationFinder: StationFinder!

    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()

    override func setUp() {
        super.setUp()
        stationFinder = ApiStationFinder(fahrplanService: fahrplanServiceMock,
                                                          stationConverter: StationConverter())
    }

    func testStationSearchSucceededOnApiSuccess() {
        // Prepare
        fahrplanServiceMock.expected = .just([FahrplanStationBuilder().build()])
        // Run
        let testObserver = testScheduler.start {
            self.stationFinder.searchStation(namePart: "")
        }
        // Test
        guard case .success? = testObserver.events.first?.value.element else {
            XCTFail("Unexpected result")
            return
        }
    }

    func testStationSearchFailsOnApiError() {
        // Prepare
        fahrplanServiceMock.expected = .error(RxError.unknown)
        // Run
        let testObserver = testScheduler.start {
            self.stationFinder.searchStation(namePart: "")
        }
        // Test
        guard case .error? = testObserver.events.first?.value.element else {
            XCTFail("Unexpected result")
            return
        }
    }
}
