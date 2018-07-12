//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

struct TimetableConverter: Converter {
    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from input: ApiTimetable) -> Timetable {
        var arrivals = [Timetable.Event]()
        var departures = [Timetable.Event]()
        input.stops.forEach { stop in
            if let arrival = stop.arrival {
                arrivals.append(Timetable.Event(category: stop.tripLabel.category,
                                                number: stop.tripLabel.number,
                                                stations: arrival.path.components(separatedBy: "|"),
                                                time: _dateFormatter.date(from: arrival.time,
                                                                          style: .ApiTimetablesDateTime),
                                                platform: arrival.platform))
            }
            if let departure = stop.departure {
                departures.append(Timetable.Event(category: stop.tripLabel.category,
                                                number: stop.tripLabel.number,
                                                stations: departure.path.components(separatedBy: "|"),
                                                time: _dateFormatter.date(from: departure.time,
                                                                          style: .ApiTimetablesDateTime),
                                                platform: departure.platform))
            }
        }
        return Timetable(arrivals: arrivals, departures: departures)
    }
}
