//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct TimetableViewStateConverter: ViewStateConverter {

    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from state: TimetableState) -> TimetableViewState {
        let items: [TimetableViewState.SectionItem]
        let segmentedControlIndex = state.currentTable.rawValue
        if state.shouldLoadTimetable {
            items = [.loading]
        } else {
            switch state.timetableResult {
            case .success(let events):
                switch state.currentTable {
                case .departures:
                    items = _items(from: events.departures)
                case .arrivals:
                    items = _items(from: events.arrivals)
                }
            case .error:
                items = [.error]
            }
        }
        return TimetableViewState(sections: [TimetableViewState.Section(items: items)],
                                  segmentedControlIndex: segmentedControlIndex)
    }

    private func _items(from timeTableEvents: [Timetable.Event]) -> [TimetableViewState.SectionItem] {
        return timeTableEvents.map {
            TimetableViewState.SectionItem.event(
                TimetableEventCell.State(category: $0.category,
                                         number: $0.number,
                                         time: _dateFormatter.string(from: $0.time,
                                                                     style: .userTimetableTime),
                                         platform: $0.platform,
                                         date: _dateFormatter.string(from: $0.time,
                                                                     style: .userTimetableDate),
                                         corrStation: $0.stations.last ?? "")
            )
        }
    }
}
