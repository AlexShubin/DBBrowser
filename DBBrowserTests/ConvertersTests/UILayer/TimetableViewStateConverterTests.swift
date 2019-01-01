//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableViewStateConverterTests: XCTestCase {

    var converter: TimetableViewStateConverter!
    let timetableEventCellConverterMock = TimetableEventCellConverterMock()

    override func setUp() {
        super.setUp()
        converter = TimetableViewStateConverter(
            timetableEventCellConverter: timetableEventCellConverterMock
        )
    }

    func testLoadingConverted() {
        // Prepare
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .station(StationBuilder().build()),
            .loadTimetable
            ])
        // Run
        let converted = converter.convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        XCTAssertEqual(converted.sections.first?.items.count, 1)
        XCTAssertEqual(converted.sections.first?.items.first, .loading)
    }

    func testErrorConverted() {
        // Prepare
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoadingError
            ])
        // Run
        let converted = converter.convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        XCTAssertEqual(converted.sections.first?.items.count, 1)
        XCTAssertEqual(converted.sections.first?.items.first, .error)
    }

    func testEventCellStatePassedFromEventCellConverterToResultingState() {
        // Prepare
        timetableEventCellConverterMock.expected = TimetableEventCellStateBuilder().build()
        let timetableWithDepartures = Timetable(departures: [TimetableEventBuilder().build()])
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .corrStation(StationBuilder {
                $0.name = TestData.stationName1
                }.build()),
            .timetableLoaded(timetableWithDepartures),
            .changeTable(0)
            ])
        // Run
        let converted = converter.convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        XCTAssertEqual(converted.sections.first?.items.first,
                       .event(timetableEventCellConverterMock.expected))
    }

    func testEventCellConverterInvokedProperlyForDepartures() {
        // Prepare
        let event1 = TimetableEventBuilder().with(number: TestData.Timetable.number1).build()
        let event2 = TimetableEventBuilder().with(number: TestData.Timetable.number2).build()
        let event3 = TimetableEventBuilder().with(number: TestData.Timetable.number3).build()
        let timetableWithDepartures = Timetable(arrivals: [event3], departures: [event1, event2])
        let corrStation = StationBuilder {
            $0.evaId = TestData.stationId1
            }.build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .corrStation(corrStation),
            .timetableLoaded(timetableWithDepartures),
            .changeTable(TimetableState.Table.departures.rawValue)
            ])
        // Run
        _ = converter.convert(from: state)
        // Test
        XCTAssertEqual(timetableEventCellConverterMock.invocations,
                       [.convert(event1, .departures, corrStation),
                        .convert(event2, .departures, corrStation)])
    }

    func testEventCellConverterInvokedProperlyForArrivals() {
        // Prepare
        let event1 = TimetableEventBuilder().with(number: TestData.Timetable.number1).build()
        let event2 = TimetableEventBuilder().with(number: TestData.Timetable.number2).build()
        let event3 = TimetableEventBuilder().with(number: TestData.Timetable.number3).build()
        let timetableWithDepartures = Timetable(arrivals: [event3], departures: [event1, event2])
        let corrStation = StationBuilder {
            $0.name = TestData.stationName2
            }.build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .corrStation(corrStation),
            .timetableLoaded(timetableWithDepartures),
            .changeTable(TimetableState.Table.arrivals.rawValue)
            ])
        // Run
        _ = converter.convert(from: state)
        // Test
        XCTAssertEqual(timetableEventCellConverterMock.invocations,
                       [.convert(event3, .arrivals, corrStation)])
    }

    func testEventCellChangesAppliedAndPassedToTheCellConverter() {
        // Prepare
        let event = TimetableEventBuilder()
            .with(id: TestData.Timetable.id1)
            .with(platform: TestData.Timetable.platform1)
            .with(stations: TestData.Timetable.stationsArray1)
            .with(time: TestData.Timetable.time1)
            .build()
        let changedEvent = ChangesEventBuilder {
            $0.id = TestData.Timetable.id1
            $0.platform = TestData.Timetable.platform2
            $0.stations = TestData.Timetable.stationsArray2
            $0.time = TestData.Timetable.time2
        }.build()
        let timetable = Timetable(departures: [event])
        let changes = ChangesBuilder { $0.departures = [changedEvent] }.build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(timetable),
            .changesLoaded(changes),
            .changeTable(TimetableState.Table.departures.rawValue)
            ])
        // Run
        _ = converter.convert(from: state)
        // Test
        let expectedEvent = TimetableEventBuilder()
            .with(id: TestData.Timetable.id1)
            .with(platform: TestData.Timetable.platform2)
            .with(stations: TestData.Timetable.stationsArray2)
            .with(time: TestData.Timetable.time2)
            .build()
        XCTAssertEqual(timetableEventCellConverterMock.invocations,
                       [.convert(expectedEvent, .departures, nil)])
    }

    func testTimetableWithDeparturesInArrivalsModeConvertedToLoadMoreButton() {
        // Prepare
        let timetableWithDepartures = Timetable(arrivals: [],
                                                departures: [TimetableEventBuilder().build()])
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(timetableWithDepartures),
            .changeTable(1)
            ])
        // Run
        let converted = converter.convert(from: state)
        // Test
        guard case .loadMore(let cellState)? = converted.sections.first?.items.first else {
            XCTFail("Unexpected cell type")
            return
        }
        XCTAssertEqual(cellState, .normal)
    }

    func testTimetableWithArrivalsInDeparturessModeConvertedToLoadMoreButton() {
        // Prepare
        let timetableWithDepartures = Timetable(arrivals: [TimetableEventBuilder().build()],
                                                departures: [])
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(timetableWithDepartures),
            .changeTable(0)
            ])
        // Run
        let converted = converter.convert(from: state)
        // Test
        guard case .loadMore(let cellState)? = converted.sections.first?.items.first else {
            XCTFail("Unexpected cell type")
            return
        }
        XCTAssertEqual(cellState, .normal)
    }

    func testTimetableDeparturesTableConvertedTo0Index() {
        // Prepare
        var state = TimetableState.initial
        state.currentTable = .departures
        // Run
        let converted = converter.convert(from: state)
        // Test
        XCTAssertEqual(converted.segmentedControlIndex, 0)
    }

    func testTimetableArrivalsTableConvertedTo1Index() {
        // Prepare
        var state = TimetableState.initial
        state.currentTable = .arrivals
        // Run
        let converted = converter.convert(from: state)
        // Test
        XCTAssertEqual(converted.segmentedControlIndex, 1)
    }

    func testTimetableLoadAgainConvertedLoadingButtonState() {
        // Prepare
        let event = TimetableEventBuilder()
            .with(category: TestData.Timetable.category1)
            .with(number: TestData.Timetable.number1)
            .with(platform: TestData.Timetable.platform1)
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        let timetableWithDepartures = Timetable(arrivals: [], departures: [event])
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(timetableWithDepartures),
            .changeTable(0),
            .loadTimetable
            ])
        // Run
        let converted = converter.convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        guard case .loadMore(let cellState)? = converted.sections.first?.items.last else {
            XCTFail("Unexpected cell type")
            return
        }
        XCTAssertEqual(cellState, .loading)
    }

    func testTimetableLoadAgainAndReceivedErrorConvertedNormalButtonState() {
        // Prepare
        let event = TimetableEventBuilder()
            .with(category: TestData.Timetable.category1)
            .with(number: TestData.Timetable.number1)
            .with(platform: TestData.Timetable.platform1)
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        let timetableWithDepartures = Timetable(arrivals: [], departures: [event])
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(timetableWithDepartures),
            .changeTable(0),
            .loadTimetable,
            .timetableLoadingError
            ])
        // Run
        let converted = converter.convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        guard case .loadMore(let cellState)? = converted.sections.first?.items.last else {
            XCTFail("Unexpected cell type")
            return
        }
        XCTAssertEqual(cellState, .normal)
    }
}
