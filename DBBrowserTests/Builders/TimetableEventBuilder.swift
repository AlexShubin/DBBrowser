//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation

final class TimetableEventBuilder {
    private var _category = TestData.Timetable.category1
    private var _number = TestData.Timetable.number1
    private var _stations = [TestData.stationName1, TestData.stationName2]
    private var _time = TestData.Timetable.time1
    private var _platform = TestData.Timetable.platform1

    func with(category: String) -> TimetableEventBuilder {
        _category = category
        return self
    }

    func with(number: String) -> TimetableEventBuilder {
        _number = number
        return self
    }

    func with(stations: [String]) -> TimetableEventBuilder {
        _stations = stations
        return self
    }

    func with(time: Date) -> TimetableEventBuilder {
        _time = time
        return self
    }

    func with(platform: String) -> TimetableEventBuilder {
        _platform = platform
        return self
    }

    func build() -> Timetable.Event {
        return Timetable.Event(category: _category,
                               number: _number,
                               stations: _stations,
                               time: _time,
                               platform: _platform)
    }
}
