//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct MainScreenViewStateConverter: ViewStateConverter {
    private typealias Field = InputField.State.Field

    private var _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from state: TimetableState) -> MainScreenViewState {
        let stationField: Field
        switch state.station {
        case .none:
            stationField = .placeholder(L10n.MainScreen.stationPlaceholder)
        case .some(let station):
            stationField = .chosen(station.name)
        }
        let corrStationField: Field
        switch state.corrStation {
        case .none:
            corrStationField = .placeholder(L10n.MainScreen.corrStationPlaceholder)
        case .some(let station):
            corrStationField = .chosen(station.name)
        }
        let dateField = Field.chosen(_dateFormatter.string(from: state.date,
                                                           style: .userMainScreenDateTime))
        return MainScreenViewState(station: InputField.State(field: stationField,
                                                             caption: L10n.MainScreen.stationCaption),
                                   date: InputField.State(field: dateField,
                                                          caption: L10n.MainScreen.dateCaption),
                                   corrStation: InputField.State(field: corrStationField,
                                                                 caption: L10n.MainScreen.corrStationCaption))
    }
}
