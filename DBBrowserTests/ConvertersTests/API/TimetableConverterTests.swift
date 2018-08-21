//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableConverterTests: XCTestCase {

    var converter: ApiTimetableConverter!
    let emptyChanges = ApiChangesBuilder().with(stops: []).build()

    override func setUp() {
        super.setUp()
        converter = ApiTimetableConverter(dateFormatter: AppDateTimeFormatter())
    }

    func testArrivalElementsCountConvertedWhenDepartureAndArrivalAreInDifferentStops() {
        // Prepare
        let apiStopWithArrival = ApiStopBuilder()
            .with(arrival: ApiEventBuilder().build())
            .with(departure: nil)
            .build()
        let apiStopWithDeparture = ApiStopBuilder()
            .with(arrival: nil)
            .with(departure: ApiEventBuilder().build())
            .build()
        let apiTimetable = ApiTimetableBuilder()
            .with(stops: [apiStopWithArrival,
                          apiStopWithArrival,
                          apiStopWithArrival,
                          apiStopWithDeparture,
                          apiStopWithDeparture])
            .build()
        // Run
        let result = converter.convert(from: apiTimetable,
                                       station: StationBuilder().build())
        // Test
        XCTAssertEqual(result.arrivals.count, 3)
        XCTAssertEqual(result.departures.count, 2)
    }

    func testArrivalEventConverted() {
        // Prepare
        let apiEvent = ApiEventBuilder()
            .with(path: TestData.Timetable.stations1)
            .with(time: TestData.Timetable.timeString1)
            .with(platform: TestData.Timetable.platform1)
            .build()
        let apiTripLabel = ApiTripLabelBuilder()
            .with(category: TestData.Timetable.category1)
            .with(number: TestData.Timetable.number1)
            .build()
        let apiStop = ApiStopBuilder()
            .with(tripLabel: apiTripLabel)
            .with(arrival: apiEvent)
            .with(departure: nil)
            .with(id: TestData.Timetable.id1)
            .build()
        let apiTimetable = ApiTimetableBuilder()
            .with(stops: [apiStop])
            .build()
        let expectedStation = StationBuilder().build()
        // Run
        let result = converter.convert(from: apiTimetable,
                                       station: expectedStation)
        // Test
        XCTAssertEqual(result.arrivals.count, 1)
        XCTAssertEqual(result.departures.count, 0)
        XCTAssertEqual(result.arrivals.first,
                       Timetable.Event(id: TestData.Timetable.id1,
                                       station: expectedStation,
                                       category: TestData.Timetable.category1,
                                       number: TestData.Timetable.number1,
                                       stations: TestData.Timetable.stations1.components(separatedBy: "|"),
                                       time: TestData.Timetable.time1,
                                       platform: TestData.Timetable.platform1))
    }

    func testDepartureEventConverted() {
        // Prepare
        let apiEvent = ApiEventBuilder()
            .with(path: TestData.Timetable.stations1)
            .with(time: TestData.Timetable.timeString1)
            .with(platform: TestData.Timetable.platform1)
            .build()
        let apiTripLabel = ApiTripLabelBuilder()
            .with(category: TestData.Timetable.category1)
            .with(number: TestData.Timetable.number1)
            .build()
        let apiStop = ApiStopBuilder()
            .with(tripLabel: apiTripLabel)
            .with(arrival: nil)
            .with(departure: apiEvent)
            .build()
        let apiTimetable = ApiTimetableBuilder()
            .with(stops: [apiStop])
            .build()
        let expectedStation = StationBuilder().build()
        // Run
        let result = converter.convert(from: apiTimetable,
                                       station: expectedStation)
        // Test
        XCTAssertEqual(result.departures.count, 1)
        XCTAssertEqual(result.arrivals.count, 0)
        XCTAssertEqual(result.departures.first,
                       Timetable.Event(id: TestData.Timetable.id1,
                                       station: expectedStation,
                                       category: TestData.Timetable.category1,
                                       number: TestData.Timetable.number1,
                                       stations: TestData.Timetable.stations1.components(separatedBy: "|"),
                                       time: TestData.Timetable.time1,
                                       platform: TestData.Timetable.platform1))
    }
}
