//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct MainScreenViewStateConverter: Converter {
    func convert(from input: MainScreenState) -> MainScreenViewState {
        switch input.station {
        case .none:
            return MainScreenViewState(station: .placeholder(L10n.MainScreen.stationPlaceholder))
        case .some(let station):
            return MainScreenViewState(station: .chosen(station.name))
        }
    }
}
