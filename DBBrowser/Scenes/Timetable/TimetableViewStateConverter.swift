//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct TimetableViewStateConverter: ViewStateConverter {

    private let _timetableEventCellConverter: TimetableEventCellConverterType

    init(timetableEventCellConverter: TimetableEventCellConverterType) {
        _timetableEventCellConverter = timetableEventCellConverter
    }

    func convert(from state: TimetableState) -> TimetableViewState {
        var items = _eventsItems(from: state.timetable,
                                 changes: state.changes,
                                 table: state.currentTable,
                                 userCorrStation: state.corrStation)
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
                              changes: Changes?,
                              table: TimetableState.Table,
                              userCorrStation: Station?) -> [TimetableViewState.SectionItem] {
        var events: [Timetable.Event]
        let changedEvents: [Changes.Event]?
        switch table {
        case .departures:
            events = timetable.departures
            changedEvents = changes?.departures
        case .arrivals:
            events = timetable.arrivals
            changedEvents = changes?.arrivals
        }
        if let _changedEvents = changedEvents {
            events = _applyChanges(events: events, changes: _changedEvents)
        }
        return events.map {
            .event(self._timetableEventCellConverter.convert(from: $0,
                                                             table: table,
                                                             userCorrStation: userCorrStation))
        }
    }

    private func _applyChanges(events: [Timetable.Event], changes: [Changes.Event]) -> [Timetable.Event] {
        return events.map { event in
            if let changed = changes.first(where: { $0.id == event.id }) {
                return Timetable.Event(id: event.id,
                                       category: event.category,
                                       number: event.number,
                                       stations: changed.stations ?? event.stations,
                                       time: changed.time ?? event.time,
                                       platform: changed.platform ?? event.platform)
            }
            return event
        }
    }
}
