//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

/// Timetable stop.
struct ApiStop {
    /// An id that uniquely identifies the stop.
    /// It consists of the following three elements separated by dashes.
    ///     - a 'daily trip id' that uniquely identifies a trip within one day.
    ///             This id is typically reused on subsequent days. This could be negative.
    ///     - a 6-digit date specifier (YYMMdd) that indicates
    ///             the planned departure date of the trip from its start station.
    ///     - an index that indicates the position of the stop within the trip
    ///             (in rare cases, one trip may arrive multiple times at one station).
    ///             Added trips get indices above 100. Example '-7874571842864554321-1403311221-11'
    ///             would be used for a trip with daily trip id '-7874571842864554321' that starts
    ///             on march the 31th 2014 and where the current station is the 11th stop.
    let id: String
    /// Trip label.
    let tripLabel: ApiTripLabel
    /// Arrival element.
    let arrival: ApiEvent?
    /// Departure element.
    let departure: ApiEvent?
}
