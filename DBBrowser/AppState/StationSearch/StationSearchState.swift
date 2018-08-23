//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct StationSearchState: State, Equatable {
    typealias Event = StationSearchEvent
    static let initial = StationSearchState()

    enum Mode {
        case station, corrStation
    }

    var searchResult = StationFinderResult.success([])
    var shouldSearch = false
    var searchString = ""
    var selectedStation: Station?
    var mode = Mode.station
}

// MARK: - Events
enum StationSearchEvent: Equatable {
    case searchString(String)
    case startSearch
    case found(StationFinderResult)
    case selected(Int)
    case clear
    case mode(StationSearchState.Mode)
}

// MARK: - Queries
extension StationSearchState {
    var querySearch: String? {
        return shouldSearch ? searchString : nil
    }
    var querySelectedStation: TimetableEvent? {
        guard let station = selectedStation else {
            return nil
        }
        switch mode {
        case .station:
            return .station(station)
        case .corrStation:
            return .corrStation(station)
        }
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
            result.shouldSearch = false
        case .selected(let index):
            result.selectedStation = state._station(with: index)
        case .clear:
            result = .initial
        case .mode(let mode):
            result.mode = mode
        }
        return result
    }
}

// MARK: - Helpers
extension StationSearchState {
    private func _station(with index: Int) -> Station? {
        switch searchResult {
        case .success(let stations):
            return stations[index]
        case .error:
            return nil
        }
    }
}
