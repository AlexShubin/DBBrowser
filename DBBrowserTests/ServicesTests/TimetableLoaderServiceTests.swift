//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import XCTest
import RxSwift
@testable import DBBrowser
import RxTest

class TimetableLoaderServiceTests: XCTestCase {

    let timetableServiceMock = TimeTableServiceMock()
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
        timetableServiceMock.expected = .just(ApiTimetable(stops: []))
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
        timetableServiceMock.expected = .error(RxError.unknown)
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

    func testDeparturesSortedByTime() {
        // Prepare
        let earlierTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:20")).build()
        let laterTrain = TimetableEventBuilder().with(time: Date.testSample(from: "02-12-1987 12:30")).build()
        let departures = [laterTrain, earlierTrain]
        timetableConverterMock.expected = TimetableBuilder().with(departures: departures).build()
        timetableServiceMock.expected = .just(ApiTimetable(stops: []))
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
        timetableServiceMock.expected = .just(ApiTimetable(stops: []))
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
        timetableServiceMock.expected = .just(ApiTimetable(stops: []))
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
        timetableServiceMock.expected = .just(ApiTimetable(stops: []))
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
}

private extension Date {
    static func testSample(from str: String) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.CEST
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.date(from: str)!
    }
}
