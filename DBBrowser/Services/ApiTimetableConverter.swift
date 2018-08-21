//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

protocol TimetableConverter {
    func convert(from apiTimetable: ApiTimetable, station: Station) -> Timetable
}

struct ApiTimetableConverter: TimetableConverter {
    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from apiTimetable: ApiTimetable, station: Station) -> Timetable {
        var arrivals = [Timetable.Event]()
        var departures = [Timetable.Event]()
        apiTimetable.stops.forEach { stop in
            if let arrival = stop.arrival {
                arrivals.append(_convert(id: stop.id,
                                         station: station,
                                         tripLabel: stop.tripLabel,
                                         apiEvent: arrival))
            }
            if let departure = stop.departure {
                departures.append(_convert(id: stop.id,
                                           station: station,
                                           tripLabel: stop.tripLabel,
                                           apiEvent: departure))
            }
        }
        return Timetable(arrivals: arrivals, departures: departures)
    }

    func _convert(id: String,
                  station: Station,
                  tripLabel: ApiTripLabel,
                  apiEvent: ApiEvent) -> Timetable.Event {
        return Timetable.Event(id: id,
                               station: station,
                               category: tripLabel.category,
                               number: tripLabel.number,
                               stations: apiEvent.path.components(separatedBy: "|"),
                               time: _dateFormatter.date(from: apiEvent.time,
                                                         style: .apiTimetablesDateTime),
                               platform: apiEvent.platform)
    }
}
