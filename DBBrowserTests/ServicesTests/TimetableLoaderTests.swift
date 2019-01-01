//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import XCTest
import RxSwift
@testable import DBBrowser
import RxTest

class TimetableLoaderTests: XCTestCase {

    let timetableServiceMock = TimetableServiceMock()
    let dateFormatterMock = DateTimeFormatterMock()
    let timetableConverterMock = TimetableConverterMock()
    var timetableLoader: TimetableLoader!

    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()

    override func setUp() {
        super.setUp()
        timetableLoader = ApiTimetableLoader(timetableService: timetableServiceMock,
                                             timetableConverter: timetableConverterMock,
                                             dateFormatter: dateFormatterMock)
    }

    func testTimetableLoadingFailsOnApiError() {
        // Prepare
        timetableServiceMock.expectedTimetable = .error(RxError.unknown)
        timetableServiceMock.expectedChanges = .just(ApiChangesBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(evaId: TestData.stationId1,
                                      metaEvaIds: [],
                                      date: TestData.date1,
                                      corrStation: nil)
        }
        // Test
        XCTAssertNotNil(testObserver.events.first?.value.error)
    }

    func testDeparturesSortedByTime() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let departures = [laterTrain, earlierTrain]
        timetableConverterMock.expected = Timetable(departures: departures)
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(evaId: TestData.stationId1,
                                      metaEvaIds: [],
                                      date: Date(timeIntervalSince1970: 1000000),
                                      corrStation: nil)
        }
        // Test
        XCTAssertEqual(testObserver.firstElement?.departures, [earlierTrain, laterTrain])
    }

    func testArrivalsSortedByTime() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let arrivals = [laterTrain, earlierTrain]
        timetableConverterMock.expected = Timetable(arrivals: arrivals)
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(evaId: TestData.stationId1,
                                      metaEvaIds: [],
                                      date: Date(timeIntervalSince1970: 1000000),
                                      corrStation: nil)
        }
        // Test
        XCTAssertEqual(testObserver.firstElement?.arrivals, [earlierTrain, laterTrain])
    }

    func testTrimsOutdatedDepartures() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let departures = [laterTrain, earlierTrain]
        timetableConverterMock.expected = Timetable(departures: departures)
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(evaId: TestData.stationId1,
                                      metaEvaIds: [],
                                      date: Date.testSample(from: "02-12-1987 12:25"),
                                      corrStation: nil)
        }
        // Test
        XCTAssertEqual(testObserver.firstElement?.departures, [laterTrain])
    }

    func testTrimsOutdatedArrivals() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let arrivals = [laterTrain, earlierTrain]
        timetableConverterMock.expected = Timetable(arrivals: arrivals)
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(evaId: TestData.stationId1,
                                      metaEvaIds: [],
                                      date: Date.testSample(from: "02-12-1987 12:25"),
                                      corrStation: nil)
        }
        // Test
        XCTAssertEqual(testObserver.firstElement?.arrivals, [laterTrain])
    }

    func testFiltersDeparturesByCorrStation() {
        // Prepare
        let withCorrStation = TimetableEventBuilder().with(stations: ["123", "45", "789"]).build()
        let withoutCorrStation = TimetableEventBuilder().with(stations: ["1011", "1213", "1415"]).build()
        timetableConverterMock.expected = Timetable(departures: [withCorrStation, withoutCorrStation])
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(evaId: TestData.stationId1,
                                      metaEvaIds: [],
                                      date: TestData.date1,
                                      corrStation: StationBuilder { $0.name = "456" }.build())
        }
        // Test
        XCTAssertEqual(testObserver.firstElement?.departures, [withCorrStation])
    }

    func testFiltersArrivalsByCorrStation() {
        // Prepare
        let withCorrStation = TimetableEventBuilder().with(stations: ["1011", "1213", "1415"]).build()
        let withoutCorrStation = TimetableEventBuilder().with(stations: ["123", "456", "789"]).build()
        timetableConverterMock.expected = Timetable(arrivals: [withCorrStation, withoutCorrStation])
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(evaId: TestData.stationId1,
                                      metaEvaIds: [],
                                      date: TestData.date1,
                                      corrStation: StationBuilder { $0.name = "141" }.build())
        }
        // Test
        XCTAssertEqual(testObserver.firstElement?.arrivals, [withCorrStation])
    }
}

private extension Date {
    static func testSample(from str: String) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.CEST
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.date(from: str)!
    }
}
