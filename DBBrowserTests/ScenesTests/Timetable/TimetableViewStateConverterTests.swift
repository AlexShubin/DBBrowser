//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableViewStateConverterTests: XCTestCase {

    var converter: TimetableViewStateConverter!
    let dateFormatterMock = DateTimeFormatterMock()

    override func setUp() {
        super.setUp()
        converter = TimetableViewStateConverter(dateFormatter: dateFormatterMock)
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

    func testTimetableWithDeparturesConverted() {
        // Prepare
        dateFormatterMock.expectedString = "123"
        let event = TimetableEventBuilder()
            .with(category: TestData.Timetable.category1)
            .with(number: TestData.Timetable.number1)
            .build()
        let timetableWithDepartures = TimetableBuilder()
            .with(departures: [event])
            .with(arrivals: [])
            .build()
        let state = TimetableState.applyEvents(initial: .initial, events: [
            .timetableLoaded(.success(timetableWithDepartures))
            ])
        // Run
        let converted = converter.convert(from: state)
        // Test
        XCTAssertEqual(converted.sections.count, 1)
        XCTAssertEqual(converted.sections.first?.items.count, 1)
        guard case .event(let cellState)? = converted.sections.first?.items.first else {
            XCTFail("Unexpected cell type")
            return
        }
        XCTAssertEqual(cellState.category, TestData.Timetable.category1)
        XCTAssertEqual(cellState.number, TestData.Timetable.number1)
        XCTAssertEqual(cellState.time, "123")
    }
}
