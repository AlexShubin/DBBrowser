//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation

final class TimetableLoadParamsBuilder {
    private var _station = StationBuilder().build()
    private var _date = TestData.Timetable.time1

    func with(station: Station) -> TimetableLoadParamsBuilder {
        _station = station
        return self
    }

    func with(date: Date) -> TimetableLoadParamsBuilder {
        _date = date
        return self
    }

    func build() -> TimetableLoadParams {
        return TimetableLoadParams(station: _station, date: _date)
    }
}
