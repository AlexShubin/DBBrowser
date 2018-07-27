//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct TimetableViewStateConverter: Converter {

    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from input: TimetableState) -> TimetableViewState {
        let items: [TimetableViewState.SectionItem]
        let segmentedControlIndex = input.currentTable.rawValue
        if input.shouldLoadTimetable {
            items = [.loading]
        } else {
            switch input.timetableResult {
            case .success(let events):
                switch input.currentTable {
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
                                                                     style: .UserTimetableTime),
                                         platform: $0.platform,
                                         date: _dateFormatter.string(from: $0.time,
                                                                     style: .UserTimetableDate),
                                         corrStation: $0.stations.last ?? "")
            )
        }
    }
}
