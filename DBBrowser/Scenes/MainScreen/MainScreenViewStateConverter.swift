//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct MainScreenViewStateConverter: Converter {
    func convert(from input: MainScreenState) -> MainScreenViewState {
        switch input.departure {
        case .none:
            return MainScreenViewState(departure: .placeholder(L10n.MainScreen.departurePlaceholder))
        case .some(let station):
            return MainScreenViewState(departure: .chosen(station.name))
        }
    }
}
