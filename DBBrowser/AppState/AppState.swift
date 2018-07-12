//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct AppState {
    var stationSearch = StationSearchState.initial
    var mainScreen = MainScreenState.initial
    var timetable = TimetableState.initial
    static var initial: AppState {
        return AppState()
    }
}

// MARK: - Events
enum AppEvent {
    case stationSearch(StationSearchEvent)
    case mainScreen(MainScreenEvent)
    case timetable(TimetableEvent)
}

// MARK: - Reducer
extension AppState {
    static func reduce(state: AppState, event: AppEvent) -> AppState {
        var result = state
        switch event {
        case .stationSearch(let event):
            result.stationSearch = StationSearchState.reduce(state: state.stationSearch, event: event)
        case .mainScreen(let event):
            result.mainScreen = MainScreenState.reduce(state: state.mainScreen, event: event)
        case .timetable(let event):
            result.timetable = TimetableState.reduce(state: state.timetable, event: event)
        }
        return result
    }
}
