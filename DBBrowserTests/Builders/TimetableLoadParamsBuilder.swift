//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation

final class TimetableLoadParamsBuilder {
    var station = StationBuilder().build()
    var date = TestData.Timetable.time1
    var corrStation: Station?
    var shouldLoadChanges = false

    func build() -> TimetableLoadParams {
        return TimetableLoadParams(station: station,
                                   date: date,
                                   corrStation: corrStation,
                                   shouldLoadChanges: shouldLoadChanges)
    }
}
