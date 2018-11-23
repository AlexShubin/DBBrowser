//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

/// Timetable event: arrival or departure.
public struct ApiChangedEvent {
    /// Changed platform.
    public let platform: String?
    /// Changed time. New estimated or actual departure or arrival time.
    /// The time, in ten digit 'YYMMddHHmm' format, e.g. '1404011437' for 14:37 on April the 1st of 2014.
    public let time: String?
    /// Changed path.
    public let path: String?
    /// Changed status. The status of this event, a one-character indicator that is one of:
    ///     'a' = this event was added
    ///     'c' = this event was cancelled
    ///     'p' = this event was planned (also used when the cancellation of an event has been revoked).
    ///             The status applies to the event, not to the trip as a whole. Insertion or removal of a
    ///             single stop will usually affect two events at once: one arrival and one departure event.
    ///             Note that these two events do not have to belong to the same stop.
    ///             For example, removing the last stop of a trip will result in arrival cancellation
    ///             for the last stop and of departure cancellation for the stop before the last.
    ///             So asymmetric cancellations of just arrival or departure for a stop can occur.
    public let status: String?
}
