//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableReducerTests: XCTestCase {

    func testInitial() {
        let state = TimetableState.initial
        XCTAssertNil(state.station)
        XCTAssertNil(state.corrStation)
        XCTAssertEqual(state.loadingState, .success)
        XCTAssertEqual(state.timetable, Timetable(arrivals: [], departures: []))
        XCTAssertEqual(state.currentTable, .departures)
    }

    func testStationEventSetsStationAndNilsStationInfo() {
        let station = StationBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .stationInfoLoaded(StationInfoBuilder().build()),
            .station(station)
            ])
        XCTAssertEqual(state.station, station)
        XCTAssertNil(state.stationInfo)
    }

    func testCorrStationEventSetsCorrStation() {
        let station = StationBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .corrStation(station)
            ])
        XCTAssertEqual(state.corrStation, station)
    }

    func testCorrStationClearEventClearsCorrStation() {
        let station = StationBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .corrStation(station),
            .clearCorrStation
            ])
        XCTAssertNil(state.corrStation)
    }

    func testLoadTimetableEventShouldSetLoadFlag() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .loadTimetable
            ])
        XCTAssertEqual(state.loadingState, .loading)
    }

    func testTimetableLoadingErrorEventShoudSetErrorInLoadingStateAndDontAffectTimetable() {
        // Prepare
        let timetable = Timetable.empty
        // Run
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build()),
            .loadTimetable,
            .timetableLoaded(timetable),
            .loadTimetable,
            .timetableLoadingError
            ])
        // Test
        XCTAssertEqual(state.timetable, timetable)
        XCTAssertEqual(state.loadingState, .error)
    }

    func testTimetableLoadedEventShoudSetTimetableInStateAndNextSetsShouldAddTimetableEvents() {
        // Prepare
        let timetable1 = Timetable.empty
        let timetable2 = Timetable.empty
        // Run
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build()),
            .loadTimetable,
            .timetableLoaded(timetable1),
            .loadTimetable,
            .timetableLoaded(timetable2)
            ])
        // Test
        let timetableSum = Timetable(arrivals: timetable1.arrivals + timetable2.arrivals,
                                     departures: timetable1.departures + timetable2.departures)
        XCTAssertEqual(state.timetable, timetableSum)
        XCTAssertEqual(state.loadingState, .success)
    }

    func testTimetableLoadedWithChangesEventShoudSetTimetableAndChanges() {
        // Prepare
        let timetable1 = Timetable.empty
        let changes1 = ChangesBuilder().build()
        // Run
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build()),
            .loadTimetable,
            .timetableLoaded(timetable1),
            .changesLoaded(changes1)
            ])
        // Test
        XCTAssertEqual(state.timetable, timetable1)
        XCTAssertEqual(state.changes, changes1)
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
            .changesLoaded(ChangesBuilder().build()),
            .timetableLoaded(Timetable.empty),
            .reset
            ])
        XCTAssertEqual(state.timetable, Timetable.empty)
        XCTAssertEqual(state.date, state.dateToLoad)
        XCTAssertNil(state.changes)
    }

    func testDateEventSetsTheDate() {
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .date(TestData.date1)
            ])
        XCTAssertEqual(state.date, TestData.date1)
    }

    func testStationInfoEventSetsEvent() {
        let info = StationInfoBuilder().build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .stationInfoLoaded(info)
            ])
        XCTAssertEqual(state.stationInfo, info)
    }
}
