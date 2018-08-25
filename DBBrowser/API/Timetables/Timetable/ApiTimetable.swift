//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct ApiTimetable {
    let stops: [ApiStop]
}

func + (lhs: ApiTimetable, rhs: ApiTimetable) -> ApiTimetable {
    return ApiTimetable(stops: lhs.stops + rhs.stops)
}

//swiftlint:disable shorthand_operator
func += (lhs: inout ApiTimetable, rhs: ApiTimetable) {
    lhs = lhs + rhs
}
//swiftlint:enable shorthand_operator
