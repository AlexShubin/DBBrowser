//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
@testable import DBAPI

final class ApiChangesBuilder {
    private var _stops = [ApiChangedStop]()

    func with(stops: [ApiChangedStop]) -> ApiChangesBuilder {
        _stops = stops
        return self
    }

    func build() -> ApiChanges {
        return .init(stops: _stops)
    }
}
