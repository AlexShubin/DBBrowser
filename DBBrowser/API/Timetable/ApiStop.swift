//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

/// Timetable stop.
struct ApiStop {
    /// Trip label.
    let tripLabel: ApiTripLabel
    /// Arrival element.
    let arrival: ApiEvent?
    /// Departure element.
    let departure: ApiEvent?
}
