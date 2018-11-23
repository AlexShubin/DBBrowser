//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

public struct ApiChanges {
    public static let empty = ApiChanges(stops: [])

    public let stops: [ApiChangedStop]
}

public func + (lhs: ApiChanges, rhs: ApiChanges) -> ApiChanges {
    return ApiChanges(stops: lhs.stops + rhs.stops)
}

//swiftlint:disable shorthand_operator
public func += (lhs: inout ApiChanges, rhs: ApiChanges) {
    lhs = lhs + rhs
}
//swiftlint:enable shorthand_operator
