//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import DBAPI

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
                arrivals.append(_convert(id: stop.id,
                                         tripLabel: stop.tripLabel,
                                         apiEvent: arrival))
            }
            if let departure = stop.departure {
                departures.append(_convert(id: stop.id,
                                           tripLabel: stop.tripLabel,
                                           apiEvent: departure))
            }
        }
        return Timetable(arrivals: arrivals, departures: departures)
    }

    func _convert(id: String,
                  tripLabel: ApiTripLabel,
                  apiEvent: ApiEvent) -> Timetable.Event {
        return Timetable.Event(id: id,
                               category: tripLabel.category,
                               number: tripLabel.number,
                               stations: apiEvent.path.components(separatedBy: "|"),
                               time: _dateFormatter.date(from: apiEvent.time,
                                                         style: .apiTimetablesDateTime),
                               platform: apiEvent.platform)
    }
}
