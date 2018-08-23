//
//  TimetableSideEffectsTests.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 23/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest
import RxTest
import RxSwift

class TimetableSideEffectsTests: XCTestCase {

    var timetableSideEffects: TimetableSideEffects!
    let timetableLoaderMock = TimetableLoaderMock()
    let changesLoaderMock = ChangesLoaderMock()
    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()

    var stateStore: AppStateStore!
    var sideEffects: SideEffectsMock!

    override func setUp() {
        super.setUp()
        timetableSideEffects = TimetableSideEffects(timetableLoader: timetableLoaderMock,
                                                    changesLoader: changesLoaderMock)
    }

    func testTimetableLoaderInvokedWhenDontNeedToLoadChanges() {
        // Prepare
        let station = StationBuilder().build()
        // Run
        _ = testScheduler.start { [unowned self] in
            self.timetableSideEffects.loadTimetable(TimetableLoadParams(station: station,
                                                                        date: TestData.date1,
                                                                        corrStation: nil,
                                                                        shouldLoadChanges: false))
        }
        // Test
        XCTAssertEqual(timetableLoaderMock.invocations,
                       [.load(station: station, date: TestData.date1, corrStation: nil)])
        XCTAssertTrue(changesLoaderMock.invocations.isEmpty)
    }

    func testTimetableLoaderAndChangesLoaderInvokedWhenShoudLoadChanges() {
        // Prepare
        let station = StationBuilder().build()
        // Run
        _ = testScheduler.start { [unowned self] in
            self.timetableSideEffects.loadTimetable(TimetableLoadParams(station: station,
                                                                        date: TestData.date1,
                                                                        corrStation: nil,
                                                                        shouldLoadChanges: true))
        }
        // Test
        XCTAssertEqual(timetableLoaderMock.invocations,
                       [.load(station: station, date: TestData.date1, corrStation: nil)])
        XCTAssertEqual(changesLoaderMock.invocations,
                       [.load(station: station)])
    }

    func testTimetableAndChangesReceivedOnSuccess() {
        // Prepare
        let changes = ChangesBuilder().build()
        let timetable = TimetableBuilder().build()
        timetableLoaderMock.expected = .just(.success(TimetableBuilder().build()))
        changesLoaderMock.expected = .just(.success(changes))
        // Run
        let observer = testScheduler.start { [unowned self] in
            self.timetableSideEffects.loadTimetable(TimetableLoadParams(station: StationBuilder().build(),
                                                                        date: TestData.date1,
                                                                        corrStation: nil,
                                                                        shouldLoadChanges: true))
        }
        // Test
        XCTAssertEqual(observer.events,
                       [Recorded.next(200, AppEvent.timetable(.changesLoaded(changes))),
                        Recorded.next(200, AppEvent.timetable(.timetableLoaded(timetable))),
                        Recorded.completed(200)])
    }

    func testErrorReceivedOnTimetableLoaderError() {
        // Prepare
        let changes = ChangesBuilder().build()
        timetableLoaderMock.expected = .just(.error(.unknown))
        changesLoaderMock.expected = .just(.success(changes))
        // Run
        let observer = testScheduler.start { [unowned self] in
            self.timetableSideEffects.loadTimetable(TimetableLoadParams(station: StationBuilder().build(),
                                                                        date: TestData.date1,
                                                                        corrStation: nil,
                                                                        shouldLoadChanges: true))
        }
        // Test
        XCTAssertEqual(observer.events,
                       [Recorded.next(200, AppEvent.timetable(.timetableLoadingError)),
                        Recorded.completed(200)])
    }

    func testErrorReceivedOnChangesLoaderError() {
        // Prepare
        let timetable = TimetableBuilder().build()
        timetableLoaderMock.expected = .just(.success(timetable))
        changesLoaderMock.expected = .just(.error(.unknown))
        // Run
        let observer = testScheduler.start { [unowned self] in
            self.timetableSideEffects.loadTimetable(TimetableLoadParams(station: StationBuilder().build(),
                                                                        date: TestData.date1,
                                                                        corrStation: nil,
                                                                        shouldLoadChanges: true))
        }
        // Test
        XCTAssertEqual(observer.events,
                       [Recorded.next(200, AppEvent.timetable(.timetableLoadingError)),
                        Recorded.completed(200)])
    }

    func testTimetableReceivedOnSuccessWhenShouldntLoadChanges() {
        // Prepare
        let timetable = TimetableBuilder().build()
        timetableLoaderMock.expected = .just(.success(timetable))
        // Run
        let observer = testScheduler.start { [unowned self] in
            self.timetableSideEffects.loadTimetable(TimetableLoadParams(station: StationBuilder().build(),
                                                                        date: TestData.date1,
                                                                        corrStation: nil,
                                                                        shouldLoadChanges: false))
        }
        // Test
        XCTAssertEqual(observer.events,
                       [Recorded.next(200, AppEvent.timetable(.timetableLoaded(timetable))),
                        Recorded.completed(200)])
    }

    func testErrorReceivedOnTimetableErrorWhenShouldntLoadChanges() {
        // Prepare
        timetableLoaderMock.expected = .just(.error(.unknown))
        // Run
        let observer = testScheduler.start { [unowned self] in
            self.timetableSideEffects.loadTimetable(TimetableLoadParams(station: StationBuilder().build(),
                                                                        date: TestData.date1,
                                                                        corrStation: nil,
                                                                        shouldLoadChanges: false))
        }
        // Test
        XCTAssertEqual(observer.events,
                       [Recorded.next(200, AppEvent.timetable(.timetableLoadingError)),
                        Recorded.completed(200)])
    }
}
