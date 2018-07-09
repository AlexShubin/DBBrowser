//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct AppState {
    var stationSearch = StationSearchState.initial
    var mainScreen = MainScreenState.initial
    static var initial: AppState {
        return AppState()
    }
}

// MARK: - Events
enum AppEvent {
    case stationSearch(StationSearchEvent)
    case mainScreen(MainScreenEvent)
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
        }
        return result
    }
}
