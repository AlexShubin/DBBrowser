//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class MainScreenViewStateConverterTests: XCTestCase {

    var mainScreenViewStateConverter: MainScreenViewStateConverter!
    let dateFormatterMock = DateTimeFormatterMock()

    override func setUp() {
        super.setUp()
        mainScreenViewStateConverter = MainScreenViewStateConverter(dateFormatter: dateFormatterMock)
    }

    func testNoStationConverted() {
        // Prepare
        let state = TimetableState.initial
        // Run
        let converted = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(converted.station.caption, L10n.MainScreen.stationCaption)
        XCTAssertEqual(converted.station.field, .placeholder(L10n.MainScreen.stationPlaceholder))
        XCTAssertTrue(converted.station.isClearButtonHidden)
    }

    func testChosenStationConverted() {
        // Prepare
        var state = TimetableState.initial
        state.station = StationBuilder()
            .with(name: TestData.stationName1)
            .build()
        // Run
        let converted = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(converted.station.caption, L10n.MainScreen.stationCaption)
        XCTAssertEqual(converted.station.field, .chosen(TestData.stationName1))
        XCTAssertTrue(converted.station.isClearButtonHidden)
    }

    func testNoCorrStationConverted() {
        // Prepare
        let state = TimetableState.initial
        // Run
        let converted = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(converted.corrStation.caption, L10n.MainScreen.corrStationCaption)
        XCTAssertEqual(converted.corrStation.field, .placeholder(L10n.MainScreen.corrStationPlaceholder))
        XCTAssertFalse(converted.corrStation.isClearButtonHidden)
    }

    func testChosenCorrStationConverted() {
        // Prepare
        var state = TimetableState.initial
        state.corrStation = StationBuilder()
            .with(name: TestData.stationName1)
            .build()
        // Run
        let converted = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(converted.corrStation.caption, L10n.MainScreen.corrStationCaption)
        XCTAssertEqual(converted.corrStation.field, .chosen(TestData.stationName1))
        XCTAssertFalse(converted.corrStation.isClearButtonHidden)
    }

    func testRightDateAndStylePassedToConverter() {
        // Prepare
        var state = TimetableState.initial
        state.date = TestData.date1
        // Run
        _ = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(dateFormatterMock.invocations, ["string(from:style:)"])
        XCTAssertEqual(dateFormatterMock.inputDate, TestData.date1)
        XCTAssertEqual(dateFormatterMock.inputStyle, DateTimeFormatterStyle.userMainScreenDateTime)
    }

    func testRightStringPassedOutFromConverter() {
        // Prepare
        let state = TimetableState.initial
        dateFormatterMock.expectedString = "123"
        // Run
        let converted = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(converted.date.field, .chosen("123"))
        XCTAssertEqual(converted.date.caption, L10n.MainScreen.dateCaption)
        XCTAssertTrue(converted.date.isClearButtonHidden)
    }
}
