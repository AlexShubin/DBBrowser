//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

struct Timetable: Equatable {
    struct Event: Equatable {
        let id: String
        let category: String
        let number: String
        let stations: [String]
        let time: Date
        let platform: String
    }
    var arrivals: [Event]
    var departures: [Event]

    init(arrivals: [Event] = [], departures: [Event] = []) {
        self.arrivals = arrivals
        self.departures = departures
    }

    static let empty = Timetable()
}

func + (lhs: Timetable, rhs: Timetable) -> Timetable {
    return Timetable(arrivals: lhs.arrivals + rhs.arrivals,
                     departures: lhs.departures + rhs.departures)
}

//swiftlint:disable shorthand_operator
func += (lhs: inout Timetable, rhs: Timetable) {
    lhs = lhs + rhs
}
//swiftlint:enable shorthand_operator
