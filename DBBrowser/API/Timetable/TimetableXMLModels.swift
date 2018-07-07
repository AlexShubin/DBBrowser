//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

/// Timetable stop.
struct TimetableStop {
    
    /// Trip label.
    struct TripLabel {
        /// Owner.
        /// A unique short-form and only intended to map a trip to specific evu.
        let o: String?
        /// Category. Trip category, e.g. "ICE" or "RE".
        let c: String?
        /// Trip/train number, e.g. "4523".
        let n: String?
    }
    
    struct Event {
        /// Planned platform.
        let pp: String?
        /// Planned time. Planned departure or arrival time.
        /// The time, in ten digit 'YYMMddHHmm' format, e.g. '1404011437' for 14:37 on April the 1st of 2014.
        let pt: String?
        /// Planned Path. A sequence of station names separated by the pipe symbols ('|').
        /// E.g.: 'Mainz Hbf|Rüsselsheim|Frankfrt(M) Flughafen'.
        /// For arrival, the path indicates the stations that come before the current station.
        /// The first element then is the trip's start station.
        /// For departure, the path indicates the stations that come after the current station.
        /// The last element in the path then is the trip's destination station.
        /// Note that the current station is never included in the path (neither for arrival nor for departure).
        let ppth: String?
    }
    
    /// Trip label.
    let tl: TripLabel?
    /// Arrival element.
    let ar: Event?
    /// Departure element.
    let dp: Event?
}
