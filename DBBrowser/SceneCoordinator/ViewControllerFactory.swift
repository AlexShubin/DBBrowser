//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class ViewControllerFactory {

    private let _stationSearchViewStateConverter: StationSearchViewStateConverter
    private let _mainScreenViewStateConverter: MainScreenViewStateConverter
    private let _timetableViewStateConverter: TimetableViewStateConverter
    private var _appStateStore: StateStore!

    init(stationSearchViewStateConverter: StationSearchViewStateConverter,
         mainScreenViewStateConverter: MainScreenViewStateConverter,
         timetableViewStateConverter: TimetableViewStateConverter) {
        _stationSearchViewStateConverter = stationSearchViewStateConverter
        _mainScreenViewStateConverter = mainScreenViewStateConverter
        _timetableViewStateConverter = timetableViewStateConverter
    }

    func setUp(appStateStore: StateStore) {
        _appStateStore = appStateStore
    }

    func make(_ scene: Scene) -> UIViewController {
        switch scene {
        case .mainScreen:
            let vc = MainScreenViewController(converter: _mainScreenViewStateConverter)
            vc.subscribe(to: _appStateStore)
            return vc
        case .stationSearch:
            let vc = StationSearchViewController(converter: _stationSearchViewStateConverter)
            vc.subscribe(to: _appStateStore)
            return vc
        case .timetable:
            let vc = TimetableViewController(converter: _timetableViewStateConverter)
            vc.subscribe(to: _appStateStore)
            return vc
        }
    }
}
