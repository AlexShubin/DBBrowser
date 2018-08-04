//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class ApiChangedStopBuilder {
    private var _id = TestData.Timetable.id1
    private var _arrival: ApiChangedEvent?
    private var _departure: ApiChangedEvent?

    func with(id: String) -> ApiChangedStopBuilder {
        _id = id
        return self
    }

    func with(arrival: ApiChangedEvent?) -> ApiChangedStopBuilder {
        _arrival = arrival
        return self
    }

    func with(departure: ApiChangedEvent?) -> ApiChangedStopBuilder {
        _departure = departure
        return self
    }

    func build() -> ApiChangedStop {
        return .init(id: _id,
                     arrival: _arrival,
                     departure: _departure)
    }
}
