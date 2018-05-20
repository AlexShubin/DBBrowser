//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import XCTest
import RxSwift
@testable import DBBrowser
import RxTest

class StationFinderTests: XCTestCase {
    
    let bahnQLServiceMock = BahnQLServiceMock()
    var stationFinder: StationFinder!
    
    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        stationFinder = BahnQLStationFinder(bahnQLService: bahnQLServiceMock,
                                                          stationConverter: ApiStationConverter())
    }
    
    func testStationSearchSucceededOnApiSuccess() {
        // Prepare
        bahnQLServiceMock.expected = .just([BahnQLStationBuilder().build()])
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
    
    func testStationSearchFiltersStationsWithNilEvaId() {
        // Prepare
        bahnQLServiceMock.expected = .just([
            BahnQLStationBuilder()
                .with(primaryEvaId: nil)
                .build()
            ])
        // Run
        let testObserver = testScheduler.start {
            self.stationFinder.searchStation(namePart: "")
        }
        // Test
        guard case .success(let stations)? = testObserver.events.first?.value.element else {
            XCTFail("Unexpected result")
            return
        }
        XCTAssertTrue(stations.isEmpty)
    }
    
    func testStationSearchFailsOnApiError() {
        // Prepare
        bahnQLServiceMock.expected = .error(RxError.unknown)
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

