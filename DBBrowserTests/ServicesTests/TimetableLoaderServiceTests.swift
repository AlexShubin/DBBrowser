//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import XCTest
import RxSwift
@testable import DBBrowser
import RxTest

class TimetableLoaderServiceTests: XCTestCase {

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

    func testTimetableLoadingSucceededOnApiSuccess() {
        // Prepare
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        timetableServiceMock.expectedChanges = .just(ApiChangesBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(with: .init(station: Station(name: "", evaId: 0),
                                                  date: Date(timeIntervalSince1970: 1000000)))
        }
        // Test
        guard case .success? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
    }

    func testTimetableLoadingFailsOnApiError() {
        // Prepare
        timetableServiceMock.expectedTimetable = .error(RxError.unknown)
        timetableServiceMock.expectedChanges = .just(ApiChangesBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(with: .init(station: Station(name: "", evaId: 0),
                                                  date: Date(timeIntervalSince1970: 1000000)))
        }
        // Test
        guard case .error? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
    }

    func testTimetableAndChangesEndpointsEnvokedAtTheSameTime() {
        // Prepare
        let invocationsObserver = testScheduler.createObserver(String.self)
        timetableServiceMock.invocations
            .subscribe(invocationsObserver)
            .disposed(by: bag)
        // Run
        _ = testScheduler.start {
            self.timetableLoader.load(with: .init(station: Station(name: "", evaId: 0),
                                                  date: Date(timeIntervalSince1970: 1000000)))
        }
        // Test
        XCTAssertEqual(invocationsObserver.events
            .filter { $0 == Recorded.next(100, "loadTimetable(evaNo:date:hour:)") }
            .count,
            1
        )
        XCTAssertEqual(invocationsObserver.events
            .filter { $0 == Recorded.next(100, "loadChanges(evaNo:)") }
            .count,
            1
        )
    }

    func testDeparturesSortedByTime() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let departures = [laterTrain, earlierTrain]
        timetableConverterMock.expected = TimetableBuilder().with(departures: departures).build()
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(with: .init(station: Station(name: "", evaId: 0),
                                                  date: Date(timeIntervalSince1970: 1000000)))
        }
        // Test
        guard case .success(let timetable)? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
        XCTAssertEqual(timetable.departures, [earlierTrain, laterTrain])
    }

    func testArrivalsSortedByTime() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let arrivals = [laterTrain, earlierTrain]
        timetableConverterMock.expected = TimetableBuilder().with(arrivals: arrivals).build()
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(with: .init(station: Station(name: "", evaId: 0),
                                                  date: Date(timeIntervalSince1970: 1000000)))
        }
        // Test
        guard case .success(let timetable)? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
        XCTAssertEqual(timetable.arrivals, [earlierTrain, laterTrain])
    }

    func testTrimsOutdatedDepartures() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let departures = [laterTrain, earlierTrain]
        timetableConverterMock.expected = TimetableBuilder().with(departures: departures).build()
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(with: .init(station: Station(name: "", evaId: 0),
                                                  date: Date.testSample(from: "02-12-1987 12:25")))
        }
        // Test
        guard case .success(let timetable)? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
        XCTAssertEqual(timetable.departures, [laterTrain])
    }

    func testTrimsOutdatedArrivals() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let arrivals = [laterTrain, earlierTrain]
        timetableConverterMock.expected = TimetableBuilder().with(arrivals: arrivals).build()
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(with: .init(station: Station(name: "", evaId: 0),
                                                  date: Date.testSample(from: "02-12-1987 12:25")))
        }
        // Test
        guard case .success(let timetable)? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
        XCTAssertEqual(timetable.arrivals, [laterTrain])
    }

    func testFiltersDeparturesByCorrStation() {
        // Prepare
        let withCorrStation = TimetableEventBuilder().with(stations: ["123", "45", "789"]).build()
        let withoutCorrStation = TimetableEventBuilder().with(stations: ["1011", "1213", "1415"]).build()
        timetableConverterMock.expected = TimetableBuilder()
            .with(departures: [withCorrStation, withoutCorrStation])
            .build()
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(with: .init(station: StationBuilder().build(),
                                                  date: TestData.date1,
                                                  corrStation: StationBuilder().with(name: "456").build()))
        }
        // Test
        guard case .success(let timetable)? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
        XCTAssertEqual(timetable.departures, [withCorrStation])
    }

    func testFiltersArrivalsByCorrStation() {
        // Prepare
        let withCorrStation = TimetableEventBuilder().with(stations: ["1011", "1213", "1415"]).build()
        let withoutCorrStation = TimetableEventBuilder().with(stations: ["123", "456", "789"]).build()
        timetableConverterMock.expected = TimetableBuilder()
            .with(arrivals: [withCorrStation, withoutCorrStation])
            .build()
        timetableServiceMock.expectedTimetable = .just(ApiTimetableBuilder().build())
        // Run
        let testObserver = testScheduler.start {
            self.timetableLoader.load(with: .init(station: StationBuilder().build(),
                                                  date: TestData.date1,
                                                  corrStation: StationBuilder().with(name: "141").build()))
        }
        // Test
        guard case .success(let timetable)? = testObserver.firstElement else {
            XCTFail("Unexpected result")
            return
        }
        XCTAssertEqual(timetable.arrivals, [withCorrStation])
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
