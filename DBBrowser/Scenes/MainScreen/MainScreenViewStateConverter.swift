//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct MainScreenViewStateConverter: ViewStateConverter {
    private typealias Field = MainScreenViewState.Field

    private var _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from state: AppState) -> MainScreenViewState {
        let stationField: Field
        switch state.timetable.station {
        case .none:
            stationField = .placeholder(L10n.MainScreen.stationPlaceholder)
        case .some(let station):
            stationField = .chosen(station.name)
        }
        return MainScreenViewState(station: stationField,
                                   date: _dateFormatter.string(from: state.timetable.date,
                                                               style: .userMainScreenDateTime))
    }
}
