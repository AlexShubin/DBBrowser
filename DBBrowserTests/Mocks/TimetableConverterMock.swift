//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

class TimetableConverterMock: TimetableConverter {
    func convert(from apiTimetable: ApiTimetable) -> Timetable {
        return expected
    }

    var expected = TimetableBuilder().build()
}
