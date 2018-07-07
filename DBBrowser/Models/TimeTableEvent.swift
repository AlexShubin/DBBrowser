//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

struct TimetableEvent {
    enum EventType {
        case arrival
        case departure
    }
    let type: EventType
    let category: Category
    let number: String
    let stations: [String]
    let time: Date
}
