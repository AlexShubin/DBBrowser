//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
@testable import DBAPI

final class ApiEventBuilder {
    private var _platform = TestData.Timetable.platform1
    private var _time = TestData.Timetable.timeString1
    private var _path = TestData.Timetable.stations1

    func with(platform: String) -> ApiEventBuilder {
        _platform = platform
        return self
    }

    func with(time: String) -> ApiEventBuilder {
        _time = time
        return self
    }

    func with(path: String) -> ApiEventBuilder {
        _path = path
        return self
    }

    func build() -> ApiEvent {
        return .init(platform: _platform, time: _time, path: _path)
    }
}
