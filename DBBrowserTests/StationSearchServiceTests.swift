//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import XCTest
import RxSwift
@testable import DBBrowser
import RxTest

class StationSearchServiceTests: XCTestCase {
    
    let bahnQLServiceMock = BahnQLServiceMock()
    var stationSearchService: StationSearchService!
    
    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        stationSearchService = BahnQLStationSearchService(bahnQLService: bahnQLServiceMock,
                                                          stationConverter: ApiStationConverter())
    }
    
    func testStationSearch() {
        // Prepare
        let expectedStations = [
            BahnQLStationBuilder()
                .with(primaryEvaId: TestData.stationId1)
                .with(name: TestData.stationName1)
                .build(),
            BahnQLStationBuilder()
                .with(primaryEvaId: TestData.stationId2)
                .with(name: TestData.stationName2)
                .build()
            ]
        bahnQLServiceMock.expected = expectedStations
        
        // Run
        let testObserver = testScheduler.start {
            self.stationSearchService.searchStation(namePart: "")
        }
        
        // Test
        XCTAssertEqual(testObserver.events.first?.value.element?.count, expectedStations.count)
        XCTAssertEqual(testObserver.events.first?.value.element?.first?.evaId,
                       TestData.stationId1)
        XCTAssertEqual(testObserver.events.first?.value.element?.last?.evaId,
                       TestData.stationId2)
        XCTAssertEqual(testObserver.events.first?.value.element?.first?.name,
                       TestData.stationName1)
        XCTAssertEqual(testObserver.events.first?.value.element?.last?.name,
                       TestData.stationName2)
    }
    
}
