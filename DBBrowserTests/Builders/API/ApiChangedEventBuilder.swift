//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
@testable import DBAPI

final class ApiChangedEventBuilder {
    private var _platform: String?
    private var _time: String?
    private var _path: String?
    private var _status: String?

    func with(platform: String?) -> ApiChangedEventBuilder {
        _platform = platform
        return self
    }

    func with(time: String?) -> ApiChangedEventBuilder {
        _time = time
        return self
    }

    func with(path: String?) -> ApiChangedEventBuilder {
        _path = path
        return self
    }

    func with(status: String?) -> ApiChangedEventBuilder {
        _status = status
        return self
    }

    func build() -> ApiChangedEvent {
        return ApiChangedEvent(platform: _platform,
                               time: _time,
                               path: _path,
                               status: _status)
    }
}
