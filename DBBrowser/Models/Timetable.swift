//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

struct Timetable: Equatable {
    struct Event: Equatable {
        let category: String
        let number: String
        let stations: [String]
        let time: Date
        let platform: String
    }
    var arrivals: [Event]
    var departures: [Event]
}

func += (lhs: inout Timetable, rhs: Timetable) {
    lhs = Timetable(arrivals: lhs.arrivals + rhs.arrivals,
                    departures: lhs.departures + rhs.departures)
}
