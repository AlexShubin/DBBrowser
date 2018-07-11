//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class TimetableBuilder {
    private var _arrivals = [Timetable.Event]()
    private var _departures = [TimetableEventBuilder().build()]
    
    func with(arrivals: [Timetable.Event]) -> TimetableBuilder {
        _arrivals = arrivals
        return self
    }
    
    func with(departures: [Timetable.Event]) -> TimetableBuilder {
        _departures = departures
        return self
    }
    
    func build() -> Timetable {
        return Timetable(arrivals: _arrivals,
                         departures: _departures)
    }
}
