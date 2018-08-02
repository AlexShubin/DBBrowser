//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

extension Date {
    var startOfTheNextHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self)
        components.minute = 0
        components.hour = components.hour! + 1
        return Calendar.current.date(from: components)!
    }
}
