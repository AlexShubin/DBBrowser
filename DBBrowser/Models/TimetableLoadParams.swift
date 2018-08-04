//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

struct TimetableLoadParams: Equatable {
    var station: Station
    var date: Date
    var corrStation: Station?

    init(station: Station, date: Date, corrStation: Station? = nil) {
        self.station = station
        self.date = date
        self.corrStation = corrStation
    }
}
