//
//  ApiChangesConverter.swift
//  DBBrowser
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

protocol ChangesConverter {
    func convert(from apiChanges: ApiChanges) -> Changes
}

struct ApiChangesConverter: ChangesConverter {
    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from apiChanges: ApiChanges) -> Changes {
        var arrivals = [Changes.Event]()
        var departures = [Changes.Event]()
        apiChanges.stops.forEach { stop in
            if let arrival = stop.arrival {
                arrivals.append(_convert(id: stop.id, changedEvent: arrival))
            }
            if let departure = stop.departure {
                departures.append(_convert(id: stop.id, changedEvent: departure))
            }
        }
        return Changes(arrivals: arrivals, departures: departures)
    }

    func _convert(id: String, changedEvent: ApiChangedEvent) -> Changes.Event {
        let time = changedEvent.time.map {
            _dateFormatter.date(from: $0, style: .apiTimetablesDateTime)
        }
        let stations = changedEvent.path.flatMap {
            $0.count > 0 ? $0.components(separatedBy: "|") : nil
        }
        return Changes.Event(id: id,
                             stations: stations,
                             time: time,
                             platform: changedEvent.platform,
                             isCanceled: changedEvent.status == "c")
    }
}
