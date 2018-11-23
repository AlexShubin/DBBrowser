//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

/// Timetable trip label.
public struct ApiTripLabel: Equatable {
    /// Category. Trip category, e.g. "ICE" or "RE".
    public let category: String
    /// Trip/train number, e.g. "4523".
    public let number: String
}
