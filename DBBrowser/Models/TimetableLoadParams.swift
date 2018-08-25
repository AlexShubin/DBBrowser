//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

struct TimetableLoadParams: Equatable {
    var station: Station
    var stationInfo: StationInfo
    var date: Date
    var corrStation: Station?
    var shouldLoadChanges: Bool
}
