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
            .timetableLoaded(.error(.unknown))
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
        let timetableWithDepartures = TimetableBuilder()
            .with(departures: [TimetableEventBuilder().build()])
            .with(arrivals: [])
            .build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .corrStation(StationBuilder().with(name: TestData.stationName1).build()),
            .timetableLoaded(.success(timetableWithDepartures)),
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
        let timetableWithDepartures = TimetableBuilder()
            .with(departures: [event1, event2])
            .with(arrivals: [event3])
            .build()
        let corrStation = StationBuilder().with(evaId: TestData.stationId1).build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .corrStation(corrStation),
            .timetableLoaded(.success(timetableWithDepartures)),
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
        let timetableWithDepartures = TimetableBuilder()
            .with(departures: [event1, event2])
            .with(arrivals: [event3])
            .build()
        let corrStation = StationBuilder().with(evaId: TestData.stationId1).build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .corrStation(corrStation),
            .timetableLoaded(.success(timetableWithDepartures)),
            .changeTable(TimetableState.Table.arrivals.rawValue)
            ])
        // Run
        _ = converter.convert(from: state)
        // Test
        XCTAssertEqual(timetableEventCellConverterMock.invocations,
                       [.convert(event3, .arrivals, corrStation)])
    }

    func testTimetableWithDeparturesInArrivalsModeConvertedToLoadMoreButton() {
        // Prepare
        let timetableWithDepartures = TimetableBuilder()
            .with(departures: [TimetableEventBuilder().build()])
            .with(arrivals: [])
            .build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(.success(timetableWithDepartures)),
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

//    func testTimetableWithArrivalsConverted() {
//        // Prepare
//        dateFormatterMock.expectedString = "123"
//        let event = TimetableEventBuilder()
//            .with(category: TestData.Timetable.category1)
//            .with(number: TestData.Timetable.number1)
//            .with(platform: TestData.Timetable.platform1)
//            .with(stations: [TestData.stationName1, TestData.stationName2])
//            .build()
//        let timetableWithDepartures = TimetableBuilder()
//            .with(departures: [])
//            .with(arrivals: [event])
//            .build()
//        let state = TimetableState.applyEvents(initial: .initial, events: [
//            .corrStation(StationBuilder().with(name: TestData.stationName1).build()),
//            .timetableLoaded(.success(timetableWithDepartures)),
//            .changeTable(1)
//            ])
//        // Run
//        let converted = converter.convert(from: state)
//        // Test
//        XCTAssertEqual(converted.sections.count, 1)
//        guard case .event(let cellState)? = converted.sections.first?.items.first else {
//            XCTFail("Unexpected cell type")
//            return
//        }
//        XCTAssertEqual(cellState.categoryAndNumber.topText, TestData.Timetable.category1)
//        XCTAssertEqual(cellState.categoryAndNumber.bottomText, TestData.Timetable.number1)
//        XCTAssertEqual(cellState.platform.topText, TestData.Timetable.platform1)
//        XCTAssertEqual(cellState.platform.bottomText, L10n.Timetable.platformCaption)
//        XCTAssertEqual(cellState.timeAndDate.topText, "123")
//        XCTAssertEqual(cellState.timeAndDate.bottomText, "123")
//        XCTAssertEqual(cellState.corrStation.station, TestData.stationName1)
//        XCTAssertEqual(cellState.corrStation.caption, L10n.Timetable.from)
//    }

    func testTimetableWithArrivalsInDeparturessModeConvertedToLoadMoreButton() {
        // Prepare
        let timetableWithDepartures = TimetableBuilder()
            .with(departures: [])
            .with(arrivals: [TimetableEventBuilder().build()])
            .build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(.success(timetableWithDepartures)),
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
        let timetableWithDepartures = TimetableBuilder()
            .with(departures: [event])
            .with(arrivals: [])
            .build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(.success(timetableWithDepartures)),
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
        let timetableWithDepartures = TimetableBuilder()
            .with(departures: [event])
            .with(arrivals: [])
            .build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(.success(timetableWithDepartures)),
            .changeTable(0),
            .loadTimetable,
            .timetableLoaded(.error(.unknown))
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
//
//    func testStationThroughConverted() {
//        // Prepare
//        let timetableWithDepartures = TimetableBuilder()
//            .with(departures: [TimetableEventBuilder().build()])
//            .build()
//        let state = TimetableState.applyEvents(initial: .initial, events: [
//            .corrStation(StationBuilder().with(name: TestData.stationName1).build()),
//            .timetableLoaded(.success(timetableWithDepartures)),
//            .changeTable(0)
//            ])
//        // Run
//        let converted = converter.convert(from: state)
//        // Test
//        XCTAssertEqual(converted.sections.count, 1)
//        guard case .event(let cellState)? = converted.sections.first?.items.first else {
//            XCTFail("Unexpected cell type")
//            return
//        }
//        XCTAssertEqual(cellState.throughStation?.station, TestData.stationName1)
//        XCTAssertEqual(cellState.throughStation?.caption, L10n.Timetable.through)
//    }
}
