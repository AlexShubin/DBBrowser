//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct StationSearchState: State, Equatable {
    typealias Event = StationSearchEvent
    static let initial = StationSearchState()

    var searchResult = StationFinderResult.success([])
    var shouldSearch: String?
}

// MARK: - Events
enum StationSearchEvent {
    case search(String)
    case found(StationFinderResult)
}

// MARK: - Queries
extension StationSearchState {
    var querySearch: String? {
        return shouldSearch
    }
}

// MARK: - Reducer
extension StationSearchState {
    static func reduce(state: StationSearchState, event: StationSearchEvent) -> StationSearchState {
        var result = state
        switch event {
        case .search(let namePart):
            result.shouldSearch = namePart
        case .found(let searchResult):
            result.searchResult = searchResult
            result.shouldSearch = nil
        }
        return result
    }
}
