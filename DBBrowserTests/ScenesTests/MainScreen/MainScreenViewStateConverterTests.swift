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
        let state = AppState.initial
        // Run
        let converted = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(converted.station, .placeholder(L10n.MainScreen.stationPlaceholder))
    }

    func testChosenStationConverted() {
        // Prepare
        var state = AppState.initial
        state.timetable.station = StationBuilder()
            .with(name: TestData.stationName1)
            .build()
        // Run
        let converted = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(converted.station, .chosen(TestData.stationName1))
    }

    func testRightDateAndStylePassedToConverter() {
        // Prepare
        var state = AppState.initial
        state.mainScreen.date = TestData.date1
        // Run
        _ = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(dateFormatterMock.invocations, ["string(from:style:)"])
        XCTAssertEqual(dateFormatterMock.inputDate, TestData.date1)
        XCTAssertEqual(dateFormatterMock.inputStyle, DateTimeFormatterStyle.userMainScreenDateTime)
    }

    func testRightStringPassedOutFromConverter() {
        // Prepare
        let state = AppState.initial
        dateFormatterMock.expectedString = "123"
        // Run
        let converted = mainScreenViewStateConverter.convert(from: state)
        // Test
        XCTAssertEqual(converted.date, "123")
    }
}
