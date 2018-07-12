//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableReducerTests: XCTestCase {

    func testInitial() {
        let state = TimetableState.initial
        XCTAssertNil(state.timetableLoadParams)
        XCTAssertFalse(state.shouldLoadTimetable)
    }

    func testTimetableLoadParamsEventSetsTimetableLoadParams() {
        let timetableLoadParams = TimetableLoadParamsBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoadParams(timetableLoadParams)
            ])
        XCTAssertEqual(state.timetableLoadParams, timetableLoadParams)
    }

    func testLoadTimetableEventShouldSetLoadFlag() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .loadTimetable
            ])
        XCTAssertTrue(state.shouldLoadTimetable)
    }

    func testTimetableLoadedEventShoudSetResultInState() {
        let timetableResult: TimetableLoaderResult = .success(TimetableBuilder().build())
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(timetableResult)
            ])
        XCTAssertEqual(state.timetableResult, timetableResult)
    }
}
