//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableConverterTests: XCTestCase {

    var converter: TimetableConverter!
    let dateTimeFormatterMock = DateTimeFormatterMock()

    override func setUp() {
        super.setUp()
        converter = TimetableConverter(dateFormatter: dateTimeFormatterMock)
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
        let result = converter.convert(from: apiTimetable)
        // Test
        XCTAssertEqual(result.arrivals.count, 3)
        XCTAssertEqual(result.departures.count, 2)
    }

    func testArrivalEventConverted() {
        // Prepare
        dateTimeFormatterMock.expectedDate = TestData.Timetable.time1
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
            .build()
        let apiTimetable = ApiTimetableBuilder()
            .with(stops: [apiStop])
            .build()
        // Run
        let result = converter.convert(from: apiTimetable)
        // Test
        XCTAssertEqual(result.arrivals.count, 1)
        XCTAssertEqual(result.departures.count, 0)
        XCTAssertEqual(result.arrivals.first?.number, TestData.Timetable.number1)
        XCTAssertEqual(result.arrivals.first?.category, TestData.Timetable.category1)
        XCTAssertEqual(result.arrivals.first?.platform, TestData.Timetable.platform1)
        XCTAssertEqual(result.arrivals.first?.stations, TestData.Timetable.stations1.components(separatedBy: "|"))
        XCTAssertEqual(result.arrivals.first?.time, TestData.Timetable.time1)
    }

    func testDepartureEventConverted() {
        // Prepare
        dateTimeFormatterMock.expectedDate = TestData.Timetable.time1
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
        // Run
        let result = converter.convert(from: apiTimetable)
        // Test
        XCTAssertEqual(result.departures.count, 1)
        XCTAssertEqual(result.arrivals.count, 0)
        XCTAssertEqual(result.departures.first?.number, TestData.Timetable.number1)
        XCTAssertEqual(result.departures.first?.category, TestData.Timetable.category1)
        XCTAssertEqual(result.departures.first?.platform, TestData.Timetable.platform1)
        XCTAssertEqual(result.departures.first?.stations, TestData.Timetable.stations1.components(separatedBy: "|"))
        XCTAssertEqual(result.departures.first?.time, TestData.Timetable.time1)
    }

}
