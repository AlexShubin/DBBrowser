//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct StationSearchViewStateConverter: StateConverter {
    func convert(state: StationSearchState) -> StationSearchViewState {
        var items: [StationSearchViewState.SectionItem]
        if state.shouldSearch {
            items = [.loading]
        } else {
            switch state.searchResult {
            case .success(let stations):
                items = stations.map { .station(StationCell.State(stationName: $0.name)) }
            case .error:
                items = [.error]
            }
        }
        return StationSearchViewState(sections: [StationSearchViewState.Section(items: items)])
    }
}
