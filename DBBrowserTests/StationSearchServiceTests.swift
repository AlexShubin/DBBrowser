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
        XCTAssertEqual(testObserver.events.count, 2)
        
        let result = testObserver.events.first?.value.element
        XCTAssertEqual(result?.count, expectedStations.count)
        
        XCTAssertEqual(result?.first?.evaId, TestData.stationId1)
        XCTAssertEqual(result?.last?.evaId, TestData.stationId2)
        XCTAssertEqual(result?.first?.name,TestData.stationName1)
        XCTAssertEqual(result?.last?.name, TestData.stationName2)
    }
    
}
