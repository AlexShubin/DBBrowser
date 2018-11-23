//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
@testable import DBAPI

class TimetableConverterMock: TimetableConverter {
    func convert(from apiTimetable: ApiTimetable) -> Timetable {
        return expected
    }

    var expected = TimetableBuilder().build()
}
