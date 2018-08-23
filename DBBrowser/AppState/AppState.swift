//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct AppState: Equatable {
    var stationSearch = StationSearchState.initial
    var timetable = TimetableState.initial
    var coordinator = SceneCoordinatorState.initial
    static var initial: AppState {
        return AppState()
    }
}

// MARK: - Events
enum AppEvent: Equatable {
    case stationSearch(StationSearchEvent)
    case timetable(TimetableEvent)
    case coordinator(SceneCoordinatorEvent)
}

// MARK: - Reducer
extension AppState {
    static func reduce(state: AppState, event: AppEvent) -> AppState {
        debugPrint("EVENT: \(event)")
        var result = state
        switch event {
        case .stationSearch(let event):
            result.stationSearch = StationSearchState.reduce(state: state.stationSearch, event: event)
        case .timetable(let event):
            result.timetable = TimetableState.reduce(state: state.timetable, event: event)
        case .coordinator(let event):
            result.coordinator = SceneCoordinatorState.reduce(state: state.coordinator, event: event)
        }
        return result
    }
}
