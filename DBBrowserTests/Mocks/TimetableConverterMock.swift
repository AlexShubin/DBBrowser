//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

class TimetableConverterMock: TimetableConverter {
    func convert(from apiTimetable: ApiTimetable, changes: ApiChanges) -> Timetable {
        return expected
    }

    var expected = TimetableBuilder().build()
}
