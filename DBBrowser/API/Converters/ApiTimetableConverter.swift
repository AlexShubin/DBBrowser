//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

protocol TimetableConverter {
    func convert(from apiTimetable: ApiTimetable) -> Timetable
}

struct ApiTimetableConverter: TimetableConverter {
    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from apiTimetable: ApiTimetable) -> Timetable {
        var arrivals = [Timetable.Event]()
        var departures = [Timetable.Event]()
        apiTimetable.stops.forEach { stop in
            if let arrival = stop.arrival {
                arrivals.append(Timetable.Event(category: stop.tripLabel.category,
                                                number: stop.tripLabel.number,
                                                stations: arrival.path.components(separatedBy: "|"),
                                                time: _dateFormatter.date(from: arrival.time,
                                                                          style: .apiTimetablesDateTime),
                                                platform: arrival.platform))
            }
            if let departure = stop.departure {
                departures.append(Timetable.Event(category: stop.tripLabel.category,
                                                number: stop.tripLabel.number,
                                                stations: departure.path.components(separatedBy: "|"),
                                                time: _dateFormatter.date(from: departure.time,
                                                                          style: .apiTimetablesDateTime),
                                                platform: departure.platform))
            }
        }
        return Timetable(arrivals: arrivals, departures: departures)
    }
}
