//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct StationSearchViewStateConverter: StateConverter {
    func convert(state: StationSearchState) -> StationSearchViewState {
        switch state.stationSearch {
        case .loading:
            return .loading
        case .loaded(let result):
            switch result {
            case .success(let stations):
                return .stations(_sections(from: stations))
            case .error:
                return .error
            }
        }
    }
    
    private func _sections(from staions: [Station]) -> [StationSearchViewState.Section] {
        let items = staions.map {
            StationCell.State(stationName: $0.name)
        }
        return [
            StationSearchViewState.Section(items: items)
        ]
    }
}
