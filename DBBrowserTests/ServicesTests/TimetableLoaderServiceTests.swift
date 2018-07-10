//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import XCTest
import RxSwift
@testable import DBBrowser
import RxTest

class TimetableLoaderServiceTests: XCTestCase {
    
    let timetableServiceMock = TimeTableServiceMock()
    let dateFormatterMock = DateTimeFormatterMock()
    var timetableLoader: TimetableLoader!
    
    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        timetableLoader = ApiTimetableLoader(timetableService: timetableServiceMock,
                                             timetableConverter: TimetableConverter(dateFormatter: dateFormatterMock),
                                             dateFormatter: dateFormatterMock)
    }
    
    func testTimetableLoadingSucceededOnApiSuccess() {
        // Prepare
        timetableServiceMock.expected = .just(ApiTimetable(stops: []))
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(station: Station(name: "", evaId: 0),
                                      dateTime: Date(timeIntervalSince1970: 1000000))
        }
        // Test
        guard case .success? = testObserver.events.first?.value.element else {
            XCTFail("Unexpected result")
            return
        }
    }
    
    func testTimetableLoadingFailsOnApiError() {
        // Prepare
        timetableServiceMock.expected = .error(RxError.unknown)
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(station: Station(name: "", evaId: 0),
                                      dateTime: Date(timeIntervalSince1970: 1000000))
        }
        // Test
        guard case .error? = testObserver.events.first?.value.element else {
            XCTFail("Unexpected result")
            return
        }
    }
}
