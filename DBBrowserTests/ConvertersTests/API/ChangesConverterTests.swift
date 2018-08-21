//
//  ChangesConverterTests.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class ChangesConverterTests: XCTestCase {

    var converter: ApiChangesConverter!

    override func setUp() {
        super.setUp()
        converter = ApiChangesConverter(dateFormatter: AppDateTimeFormatter())
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
            .with(arrival: apiChangedEvent2)
            .build()
        let apiChanges = ApiChangesBuilder()
            .with(stops: [apiChangedStop1, apiChangedStop2])
            .build()
        // Run
        let result = converter.convert(from: apiChanges)
        // Test
        XCTAssertEqual(result.departures.first,
                       Changes.Event(id: TestData.Timetable.id1,
                                     stations: TestData.Timetable.stations2.components(separatedBy: "|"),
                                     time: TestData.Timetable.time2,
                                     platform: TestData.Timetable.platform2,
                                     isCanceled: false))
        XCTAssertEqual(result.arrivals.first,
                       Changes.Event(id: TestData.Timetable.id2,
                                     stations: TestData.Timetable.stations3.components(separatedBy: "|"),
                                     time: TestData.Timetable.time3,
                                     platform: TestData.Timetable.platform3,
                                     isCanceled: false))
    }
}
