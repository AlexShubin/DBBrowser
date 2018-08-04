//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

//swiftlint:disable function_body_length
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
        let result = converter.convert(from: apiTimetable, changes: emptyChanges)
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
            .build()
        let apiTimetable = ApiTimetableBuilder()
            .with(stops: [apiStop])
            .build()
        // Run
        let result = converter.convert(from: apiTimetable, changes: emptyChanges)
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
        let result = converter.convert(from: apiTimetable, changes: emptyChanges)
        // Test
        XCTAssertEqual(result.departures.count, 1)
        XCTAssertEqual(result.arrivals.count, 0)
        XCTAssertEqual(result.departures.first?.number, TestData.Timetable.number1)
        XCTAssertEqual(result.departures.first?.category, TestData.Timetable.category1)
        XCTAssertEqual(result.departures.first?.platform, TestData.Timetable.platform1)
        XCTAssertEqual(result.departures.first?.stations, TestData.Timetable.stations1.components(separatedBy: "|"))
        XCTAssertEqual(result.departures.first?.time, TestData.Timetable.time1)
    }

    func testArrivalChangesAppliedToAppropriateEvents() {
        // Prepare
        let apiChangedEvent1 = ApiChangedEventBuilder()
            .with(path: TestData.Timetable.stations2)
            .with(time: TestData.Timetable.timeString2)
            .with(platform: TestData.Timetable.platform2)
            .build()
        let apiChangedEvent2 = ApiChangedEventBuilder()
            .with(path: TestData.Timetable.stations3)
            .with(time: TestData.Timetable.timeString3)
            .with(platform: TestData.Timetable.platform3)
            .build()
        let apiChangedStop1 = ApiChangedStopBuilder()
            .with(id: TestData.Timetable.id1)
            .with(arrival: apiChangedEvent1)
            .build()
        let apiChangedStop2 = ApiChangedStopBuilder()
            .with(id: TestData.Timetable.id2)
            .with(arrival: apiChangedEvent2)
            .build()
        let apiChanges = ApiChangesBuilder()
            .with(stops: [apiChangedStop1, apiChangedStop2])
            .build()
        let apiStop1 = ApiStopBuilder()
            .with(id: TestData.Timetable.id1)
            .with(arrival: ApiEventBuilder().build())
            .build()
        let apiStop2 = ApiStopBuilder()
            .with(id: TestData.Timetable.id2)
            .with(arrival: ApiEventBuilder().build())
            .build()
        let apiTimetable = ApiTimetableBuilder()
            .with(stops: [apiStop1, apiStop2])
            .build()
        // Run
        let result = converter.convert(from: apiTimetable, changes: apiChanges)
        // Test
        guard result.arrivals.count == 2 else {
            XCTFail("Unexpected elements count")
            return
        }
        XCTAssertEqual(result.arrivals[0].platform, TestData.Timetable.platform2)
        XCTAssertEqual(result.arrivals[0].stations, TestData.Timetable.stations2.components(separatedBy: "|"))
        XCTAssertEqual(result.arrivals[0].time, TestData.Timetable.time2)
        XCTAssertEqual(result.arrivals[1].platform, TestData.Timetable.platform3)
        XCTAssertEqual(result.arrivals[1].stations, TestData.Timetable.stations3.components(separatedBy: "|"))
        XCTAssertEqual(result.arrivals[1].time, TestData.Timetable.time3)
    }

    func testDepartureChangesAppliedToAppropriateEvents() {
        // Prepare
        let apiChangedEvent1 = ApiChangedEventBuilder()
            .with(path: TestData.Timetable.stations2)
            .with(time: TestData.Timetable.timeString2)
            .with(platform: TestData.Timetable.platform2)
            .build()
        let apiChangedEvent2 = ApiChangedEventBuilder()
            .with(path: TestData.Timetable.stations3)
            .with(time: TestData.Timetable.timeString3)
            .with(platform: TestData.Timetable.platform3)
            .build()
        let apiChangedStop1 = ApiChangedStopBuilder()
            .with(id: TestData.Timetable.id1)
            .with(departure: apiChangedEvent1)
            .build()
        let apiChangedStop2 = ApiChangedStopBuilder()
            .with(id: TestData.Timetable.id2)
            .with(departure: apiChangedEvent2)
            .build()
        let apiChanges = ApiChangesBuilder()
            .with(stops: [apiChangedStop1, apiChangedStop2])
            .build()
        let apiStop1 = ApiStopBuilder()
            .with(id: TestData.Timetable.id1)
            .with(departure: ApiEventBuilder().build())
            .build()
        let apiStop2 = ApiStopBuilder()
            .with(id: TestData.Timetable.id2)
            .with(departure: ApiEventBuilder().build())
            .build()
        let apiTimetable = ApiTimetableBuilder()
            .with(stops: [apiStop1, apiStop2])
            .build()
        // Run
        let result = converter.convert(from: apiTimetable, changes: apiChanges)
        // Test
        guard result.departures.count == 2 else {
            XCTFail("Unexpected elements count")
            return
        }
        XCTAssertEqual(result.departures[0].platform, TestData.Timetable.platform2)
        XCTAssertEqual(result.departures[0].stations, TestData.Timetable.stations2.components(separatedBy: "|"))
        XCTAssertEqual(result.departures[0].time, TestData.Timetable.time2)
        XCTAssertEqual(result.departures[1].platform, TestData.Timetable.platform3)
        XCTAssertEqual(result.departures[1].stations, TestData.Timetable.stations3.components(separatedBy: "|"))
        XCTAssertEqual(result.departures[1].time, TestData.Timetable.time3)
    }
}
