//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct StationSearchViewStateConverter: Converter {
    func convert(from input: StationSearchState) -> StationSearchViewState {
        var items: [StationSearchViewState.SectionItem]
        if input.shouldSearch {
            items = [.loading]
        } else {
            switch input.searchResult {
            case .success(let stations):
                items = stations.map { .station(StationCell.State(stationName: $0.name)) }
            case .error:
                items = [.error]
            }
        }
        return StationSearchViewState(sections: [StationSearchViewState.Section(items: items)])
    }
}
