//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct TimetableViewStateConverter: ViewStateConverter {

    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from state: TimetableState) -> TimetableViewState {
        var items = _eventsItems(from: state.timetable,
                                 table: state.currentTable)
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

    private func _eventsItems(from timetable: Timetable,
                              table: TimetableState.Table) -> [TimetableViewState.SectionItem] {
        let corrStationCaption: String
        let events: [Timetable.Event]
        switch table {
        case .departures:
            corrStationCaption = L10n.Timetable.towards
            events = timetable.departures
        case .arrivals:
            corrStationCaption = L10n.Timetable.from
            events = timetable.arrivals
        }
        return events.map {
            let corrStation: String
            switch table {
            case .departures:
                corrStation = $0.stations.last ?? ""
            case .arrivals:
                corrStation = $0.stations.first ?? ""
            }
            return TimetableViewState.SectionItem.event(
                TimetableEventCell.State(category: $0.category,
                                         number: $0.number,
                                         time: _dateFormatter.string(from: $0.time,
                                                                     style: .userTimetableTime),
                                         platform: $0.platform,
                                         date: _dateFormatter.string(from: $0.time,
                                                                     style: .userTimetableDate),
                                         corrStationCaption: corrStationCaption,
                                         corrStation: corrStation)
            )
        }
    }
}
