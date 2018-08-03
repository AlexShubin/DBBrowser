//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class ApiStopBuilder {
    private var _id = TestData.Timetable.id1
    private var _tripLabel = ApiTripLabelBuilder().build()
    private var _arrival: ApiEvent? = ApiEventBuilder().build()
    private var _departure: ApiEvent? = ApiEventBuilder().build()

    func with(id: String) -> ApiStopBuilder {
        _id = id
        return self
    }

    func with(tripLabel: ApiTripLabel) -> ApiStopBuilder {
        _tripLabel = tripLabel
        return self
    }

    func with(arrival: ApiEvent?) -> ApiStopBuilder {
        _arrival = arrival
        return self
    }

    func with(departure: ApiEvent?) -> ApiStopBuilder {
        _departure = departure
        return self
    }

    func build() -> ApiStop {
        return .init(id: _id, tripLabel: _tripLabel, arrival: _arrival, departure: _departure)
    }
}
