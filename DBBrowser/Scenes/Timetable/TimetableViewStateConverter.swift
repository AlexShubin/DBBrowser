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
                              table: TimetableState.Table,
                              userCorrStation: Station?) -> [TimetableViewState.SectionItem] {
        let events: [Timetable.Event]
        switch table {
        case .departures:
            events = timetable.departures
        case .arrivals:
            events = timetable.arrivals
        }
        return events.map {
            .event(self._timetableEventCellConverter.convert(from: $0,
                                                             table: table,
                                                             userCorrStation: userCorrStation))
        }
    }
}
