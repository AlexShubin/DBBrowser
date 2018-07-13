//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct TimetableViewStateConverter: Converter {

    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from input: TimetableState) -> TimetableViewState {
        var items: [TimetableViewState.SectionItem]
        if input.shouldLoadTimetable {
            items = [.loading]
        } else {
            switch input.timetableResult {
            case .success(let events):
                items = events.departures.map {
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
            case .error:
                items = [.error]
            }
        }
        return TimetableViewState(sections: [TimetableViewState.Section(items: items)])
    }
}
