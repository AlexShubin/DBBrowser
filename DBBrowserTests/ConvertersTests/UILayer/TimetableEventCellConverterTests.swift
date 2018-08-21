//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class TimetableEventCellConverterTests: XCTestCase {

    var converter: TimetableEventCellConverterType!
    let dateFormatterMock = DateTimeFormatterMock()

    override func setUp() {
        super.setUp()
        converter = TimetableEventCellConverter(dateFormatter: dateFormatterMock)
    }

    func testStaticDataConverted() {
        // Prepare
        dateFormatterMock.expectedString = "123"
        let event = TimetableEventBuilder()
            .with(category: TestData.Timetable.category1)
            .with(number: TestData.Timetable.number1)
            .with(platform: TestData.Timetable.platform1)
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        // Run
        let cellState = converter.convert(from: event, table: .departures, userCorrStation: nil)
        // Test
        XCTAssertEqual(cellState.categoryAndNumber.topText, TestData.Timetable.category1)
        XCTAssertEqual(cellState.categoryAndNumber.bottomText, TestData.Timetable.number1)
        XCTAssertEqual(cellState.platform.topText, TestData.Timetable.platform1)
        XCTAssertEqual(cellState.platform.bottomText, L10n.Timetable.platformCaption)
        XCTAssertEqual(cellState.timeAndDate.topText, "123")
        XCTAssertEqual(cellState.timeAndDate.bottomText, "123")
    }

    func testCorrStationConvertedForDepartures() {
        // Prepare
        dateFormatterMock.expectedString = "123"
        let event = TimetableEventBuilder()
            .with(category: TestData.Timetable.category1)
            .with(number: TestData.Timetable.number1)
            .with(platform: TestData.Timetable.platform1)
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        // Run
        let cellState = converter.convert(from: event, table: .departures, userCorrStation: nil)
        // Test
        XCTAssertEqual(cellState.corrStation.station, TestData.stationName2)
        XCTAssertEqual(cellState.corrStation.caption, L10n.Timetable.towards)
    }

    func testCorrStationConvertedForArrivals() {
        // Prepare
        dateFormatterMock.expectedString = "123"
        let event = TimetableEventBuilder()
            .with(category: TestData.Timetable.category1)
            .with(number: TestData.Timetable.number1)
            .with(platform: TestData.Timetable.platform1)
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        // Run
        let cellState = converter.convert(from: event, table: .arrivals, userCorrStation: nil)
        // Test
        XCTAssertEqual(cellState.corrStation.station, TestData.stationName1)
        XCTAssertEqual(cellState.corrStation.caption, L10n.Timetable.from)
    }

    func testStationThroughForDeparturesConvertedWhenUserCorrStationAndRealCorrStationAreDifferent() {
        // Prepare
        let event = TimetableEventBuilder()
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        let userCorrStation = StationBuilder {
            $0.name = TestData.stationName1
            }.build()
        // Run
        let cellState = converter.convert(from: event,
                                          table: .departures,
                                          userCorrStation: userCorrStation)
        // Test
        XCTAssertEqual(cellState.throughStation?.station, TestData.stationName1)
        XCTAssertEqual(cellState.throughStation?.caption, L10n.Timetable.through)
    }

    func testStationThroughForArrivalsConvertedWhenUserCorrStationAndRealCorrStationAreDifferent() {
        // Prepare
        let event = TimetableEventBuilder()
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        let userCorrStation = StationBuilder {
            $0.name = TestData.stationName2
            }.build()
        // Run
        let cellState = converter.convert(from: event,
                                          table: .arrivals,
                                          userCorrStation: userCorrStation)
        // Test
        XCTAssertEqual(cellState.throughStation?.station, TestData.stationName2)
        XCTAssertEqual(cellState.throughStation?.caption, L10n.Timetable.through)
    }

    func testStationThroughForDeparturesConvertedToNilWhenUserCorrStationAndRealCorrStationAreTheSame() {
        // Prepare
        let event = TimetableEventBuilder()
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        let userCorrStation = StationBuilder {
            $0.name = TestData.stationName2
            }.build()
        // Run
        let cellState = converter.convert(from: event,
                                          table: .departures,
                                          userCorrStation: userCorrStation)
        // Test
        XCTAssertNil(cellState.throughStation?.station)
    }

    func testStationThroughForArrivalsConvertedToNilWhenUserCorrStationAndRealCorrStationAreTheSame() {
        // Prepare
        let event = TimetableEventBuilder()
            .with(stations: [TestData.stationName1, TestData.stationName2])
            .build()
        let userCorrStation = StationBuilder {
            $0.name = TestData.stationName1
            }.build()
        // Run
        let cellState = converter.convert(from: event,
                                          table: .arrivals,
                                          userCorrStation: userCorrStation)
        // Test
        XCTAssertNil(cellState.throughStation?.station)
    }

    func testEmptyPlatformConvertedToQuestionMark() {
        // Prepare
        let event = TimetableEventBuilder()
            .with(platform: "")
            .build()
        // Run
        let cellState = converter.convert(from: event, table: .departures, userCorrStation: nil)
        // Test
        XCTAssertEqual(cellState.platform.topText, "?")
    }
}
