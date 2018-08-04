//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct ApiChanges {
    let stops: [ApiChangedStop]
}

func + (lhs: ApiChanges, rhs: ApiChanges) -> ApiChanges {
    return ApiChanges(stops: lhs.stops + rhs.stops)
}

//swiftlint:disable shorthand_operator
func += (lhs: inout ApiChanges, rhs: ApiChanges) {
    lhs = lhs + rhs
}
//swiftlint:enable shorthand_operator
