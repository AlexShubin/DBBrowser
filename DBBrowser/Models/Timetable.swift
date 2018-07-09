//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

struct Timetable {
    struct Event {
        let category: String
        let number: String
        let stations: [String]
        let time: Date
        let platform: String
    }
    let arrivals: [Event]
    let departures: [Event]
}
