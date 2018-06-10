//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct StationSearchState: State, Equatable {
    typealias Event = StationSearchEvent
    static let initial = StationSearchState()

    var searchResult = StationFinderResult.success([])
    var shouldSearch = false
    var searchString = ""
}

// MARK: - Events
enum StationSearchEvent {
    case searchString(String)
    case startSearch
    case found(StationFinderResult)
}

// MARK: - Queries
extension StationSearchState {
    var querySearch: String? {
        return shouldSearch ? searchString : nil
    }
}

// MARK: - Reducer
extension StationSearchState {
    static func reduce(state: StationSearchState, event: StationSearchEvent) -> StationSearchState {
        var result = state
        switch event {
        case .startSearch:
            result.shouldSearch = true
        case .found(let searchResult):
            result.searchResult = searchResult
            result.shouldSearch = false
        case .searchString(let str):
            result.searchString = str
        }
        return result
    }
}
