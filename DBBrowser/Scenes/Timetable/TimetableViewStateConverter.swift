//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct TimetableViewStateConverter: ViewStateConverter {

    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from state: TimetableState) -> TimetableViewState {
        var items = [TimetableViewState.SectionItem]()
        switch state.currentTable {
        case .departures:
            items += _items(from: state.timetable.departures, corrStationCaption: L10n.Timetable.towards)
        case .arrivals:
            items += _items(from: state.timetable.arrivals, corrStationCaption: L10n.Timetable.from)
        }
        switch state.loadingState {
        case .error:
            if items.count > 0 {
                items += [.loadMore(.normal)]
            } else {
                items = [.error]
            }
        case .success:
            items += [.loadMore(.normal)]
        case .loading:
            if items.count > 0 {
                items += [.loadMore(.loading)]
            } else {
                items = [.loading]
            }
        }
        return TimetableViewState(sections: [TimetableViewState.Section(items: items)],
                                  segmentedControlIndex: state.currentTable.rawValue)
    }

    private func _items(from timeTableEvents: [Timetable.Event],
                        corrStationCaption: String) -> [TimetableViewState.SectionItem] {
        return timeTableEvents.map {
            TimetableViewState.SectionItem.event(
                TimetableEventCell.State(category: $0.category,
                                         number: $0.number,
                                         time: _dateFormatter.string(from: $0.time,
                                                                     style: .userTimetableTime),
                                         platform: $0.platform,
                                         date: _dateFormatter.string(from: $0.time,
                                                                     style: .userTimetableDate),
                                         corrStationCaption: corrStationCaption,
                                         corrStation: $0.stations.last ?? "")
            )
        }
    }
}
