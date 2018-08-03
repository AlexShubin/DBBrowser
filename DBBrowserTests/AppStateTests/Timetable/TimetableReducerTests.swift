//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableReducerTests: XCTestCase {

    func testInitial() {
        let state = TimetableState.initial
        XCTAssertNil(state.station)
        XCTAssertEqual(state.loadingState, .success)
        XCTAssertEqual(state.timetable, Timetable(arrivals: [], departures: []))
        XCTAssertEqual(state.currentTable, .departures)
    }

    func testStationEventSetsStation() {
        let station = StationBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(station)
            ])
        XCTAssertEqual(state.station, station)
    }

    func testLoadTimetableEventShouldSetLoadFlag() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .loadTimetable
            ])
        XCTAssertEqual(state.loadingState, .loading)
    }

    func testTimetableLoadingErrorEventShoudSetErrorInLoadingStateAndDontAffectTimetable() {
        // Prepare
        let timetable = TimetableBuilder().build()
        let success: TimetableLoaderResult = .success(timetable)
        let error: TimetableLoaderResult = .error(.unknown)
        // Run
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build()),
            .loadTimetable,
            .timetableLoaded(success),
            .loadTimetable,
            .timetableLoaded(error)
            ])
        // Test
        XCTAssertEqual(state.timetable, timetable)
        XCTAssertEqual(state.loadingState, .error)
    }

    func testTimetableLoadedEventShoudSetTimeTableInStateAndNextSetsShouldAddTimetableEvents() {
        // Prepare
        let timetable1 = TimetableBuilder().build()
        let timetable2 = TimetableBuilder().build()
        // Run
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build()),
            .loadTimetable,
            .timetableLoaded(.success(timetable1)),
            .loadTimetable,
            .timetableLoaded(.success(timetable2))
            ])
        // Test
        let timetableSum = TimetableBuilder()
            .with(arrivals: timetable1.arrivals + timetable2.arrivals)
            .with(departures: timetable1.departures + timetable2.departures)
            .build()
        XCTAssertEqual(state.timetable, timetableSum)
        XCTAssertEqual(state.loadingState, .success)
    }

    func testChangeTableWithIndex0ShouldSetCurrentTableToDepartures() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .changeTable(0)
            ])
        XCTAssertEqual(state.currentTable, .departures)
    }

    func testChangeTableWithIndex1ShouldSetCurrentTableToArrivals() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .changeTable(1)
            ])
        XCTAssertEqual(state.currentTable, .arrivals)
    }

    func testResetEventResetsDateAndEmptiesTimetable() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build()),
            .loadTimetable,
            .timetableLoaded(.success(TimetableBuilder().build())),
            .reset
            ])
        XCTAssertEqual(state.timetable, Timetable.empty)
        XCTAssertEqual(state.date, state.dateToLoad)
    }
}
