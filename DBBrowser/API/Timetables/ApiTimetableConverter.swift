//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

protocol TimetableConverter {
    func convert(from apiTimetable: ApiTimetable, changes: ApiChanges) -> Timetable
}

struct ApiTimetableConverter: TimetableConverter {
    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from apiTimetable: ApiTimetable, changes: ApiChanges) -> Timetable {
        var arrivals = [Timetable.Event]()
        var departures = [Timetable.Event]()
        apiTimetable.stops.forEach { stop in
            if let arrival = stop.arrival {
                let changedEvent = changes.stops.first { $0.id == stop.id }?.arrival
                arrivals.append(_convert(id: stop.id,
                                         tripLabel: stop.tripLabel,
                                         apiEvent: arrival,
                                         apiChangedEvent: changedEvent))
            }
            if let departure = stop.departure {
                let changedEvent = changes.stops.first { $0.id == stop.id }?.departure
                departures.append(_convert(id: stop.id,
                                           tripLabel: stop.tripLabel,
                                           apiEvent: departure,
                                           apiChangedEvent: changedEvent))
            }
        }
        return Timetable(arrivals: arrivals, departures: departures)
    }

    func _convert(id: String,
                  tripLabel: ApiTripLabel,
                  apiEvent: ApiEvent,
                  apiChangedEvent: ApiChangedEvent?) -> Timetable.Event {
        let path = apiChangedEvent?.path ?? apiEvent.path
        let time = apiChangedEvent?.time ?? apiEvent.time
        let platform = apiChangedEvent?.platform ?? apiEvent.platform
        return Timetable.Event(id: id,
                               category: tripLabel.category,
                               number: tripLabel.number,
                               stations: path.components(separatedBy: "|"),
                               time: _dateFormatter.date(from: time,
                                                         style: .apiTimetablesDateTime),
                               platform: platform)
    }
}
