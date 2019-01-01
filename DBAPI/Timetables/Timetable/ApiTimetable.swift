//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

public struct ApiTimetable {
    public static let empty = ApiTimetable(stops: [])

    public let stops: [ApiStop]
}

extension ApiTimetable {
    static public func + (lhs: ApiTimetable, rhs: ApiTimetable) -> ApiTimetable {
        return ApiTimetable(stops: lhs.stops + rhs.stops)
    }

    //swiftlint:disable shorthand_operator
    static public func += (lhs: inout ApiTimetable, rhs: ApiTimetable) {
        lhs = lhs + rhs
    }
    //swiftlint:enable shorthand_operator
}
