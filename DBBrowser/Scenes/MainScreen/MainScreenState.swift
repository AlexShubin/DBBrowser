//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct MainScreenState: State, Equatable {
    typealias Event = MainScreenEvent
    static let initial = MainScreenState()
    
    var departure: Station?
    
    var shouldOpenStationSearch = false
}

// MARK: - Events
enum MainScreenEvent {
    case departure(Station)
    case openStationSearch
    case stationSearchOpened
}

// MARK: - Queries
extension MainScreenState {
    var queryOpenStationSearch: Void? {
        return shouldOpenStationSearch ? () : nil
    }
}

// MARK: - Reducer
extension MainScreenState {
    static func reduce(state: MainScreenState, event: MainScreenEvent) -> MainScreenState {
        var result = state
        switch event {
        case .departure(let station):
            result.departure = station
        case .openStationSearch:
            result.shouldOpenStationSearch = true
        case .stationSearchOpened:
            result.shouldOpenStationSearch = false
        }
        return result
    }
}
