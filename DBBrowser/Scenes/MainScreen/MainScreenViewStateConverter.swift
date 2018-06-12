//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct MainScreenViewStateConverter: StateConverter {
    func convert(state: MainScreenState) -> MainScreenViewState {
        switch state.departure {
        case .none:
            return MainScreenViewState(departure: .placeholder(L10n.MainScreen.departurePlaceholder))
        case .some(let station):
            return MainScreenViewState(departure: .chosen(station.name))
        }
    }
}
