//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class ApiTimetableBuilder {
    private var _stops = [ApiStopBuilder().build()]

    func with(stops: [ApiStop]) -> ApiTimetableBuilder {
        _stops = stops
        return self
    }

    func build() -> ApiTimetable {
        return .init(stops: _stops)
    }
}
