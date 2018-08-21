//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

/// Timetable event: arrival or departure.
struct ApiEvent: Equatable {
    /// Planned platform.
    let platform: String
    /// Planned time. Planned departure or arrival time.
    /// The time, in ten digit 'YYMMddHHmm' format, e.g. '1404011437' for 14:37 on April the 1st of 2014.
    let time: String
    /// Planned Path. A sequence of station names separated by the pipe symbols ('|').
    /// E.g.: 'Mainz Hbf|Rüsselsheim|Frankfrt(M) Flughafen'.
    /// For arrival, the path indicates the stations that come before the current station.
    /// The first element then is the trip's start station.
    /// For departure, the path indicates the stations that come after the current station.
    /// The last element in the path then is the trip's destination station.
    /// Note that the current station is never included in the path (neither for arrival nor for departure).
    let path: String
}
