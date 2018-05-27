//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct StationSearchState: State, Equatable {
    typealias Event = StationSearchEvent
    static let initial = StationSearchState()
    
    enum StationSearch: Equatable {
        case loading
        case loaded(StationFinderResult)
    }

    enum Action: Equatable {
        case search(String)
    }

    var stationSearch = StationSearch.loaded(.success([]))
    var actionToPerform: Action?
}

// MARK: - Events
enum StationSearchEvent {
    case search(String)
    case found(StationFinderResult)
}

// MARK: - Queries
extension StationSearchState {
    var querySearch: String? {
        guard case .search(let namePart)? = actionToPerform else {
            return nil
        }
        return namePart
    }
}

// MARK: - Reducer
extension StationSearchState {
    static func reduce(state: StationSearchState, event: StationSearchEvent) -> StationSearchState {
        var result = state
        switch event {
        case .search(let namePart):
            if state.stationSearch != .loading {
                result.stationSearch = .loading
                result.actionToPerform = .search(namePart)
            }
        case .found(let searchResult):
            result.stationSearch = .loaded(searchResult)
            result.actionToPerform = nil
        }
        return result
    }
}
