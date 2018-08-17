//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

extension Date {
    var startOfTheNextHour: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        components.minute = 0
        components.hour = components.hour! + 1
        return calendar.date(from: components)!
    }
}
