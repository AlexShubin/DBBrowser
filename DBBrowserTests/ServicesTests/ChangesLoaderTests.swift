//
//  ChangesLoaderTests.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import XCTest
import RxSwift
@testable import DBBrowser
import RxTest

class ChangesLoaderTests: XCTestCase {

    let timetableServiceMock = TimetableServiceMock()
    let dateFormatterMock = DateTimeFormatterMock()
    let changesConverterMock = ChangesConverterMock()
    var changesLoader: ChangesLoader!

    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()

    override func setUp() {
        super.setUp()
        changesLoader = ApiChangesLoader(timetableService: timetableServiceMock,
                                         changesConverter: changesConverterMock,
                                         dateFormatter: dateFormatterMock)
    }

    func testChangesPassedFromConverterOnApiSuccess() {
        // Prepare
        timetableServiceMock.expectedChanges = .just(ApiChangesBuilder().build())
        changesConverterMock.expected = ChangesBuilder().build()
        // Run
        let testObserver = testScheduler.start {
            self.changesLoader.load(with: "")
        }
        // Test
        XCTAssertEqual(testObserver.firstElement, .success(changesConverterMock.expected))
    }

    func testChangesLoadingFailsOnApiError() {
        // Prepare
        timetableServiceMock.expectedChanges = .error(RxError.unknown)
        // Run
        let testObserver = testScheduler.start {
            self.changesLoader.load(with: "")
        }
        // Test
        guard case .error? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
    }
}
