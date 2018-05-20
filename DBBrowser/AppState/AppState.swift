//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct AppState {
    //Scenes
    var stationSearch = StationSearchState.initial
    
    static var initial: AppState {
        return AppState()
    }
}

// MARK: - Events
enum AppEvent {
    case stationSearch(StationSearchEvent)
}

// MARK: - Reducer
extension AppState {
    static func reduce(state: AppState, event: AppEvent) -> AppState {
        var result = state
        switch event {
        case .stationSearch(let event):
            result.stationSearch = StationSearchState.reduce(state: state.stationSearch, event: event)
        }
        return result
    }
}

