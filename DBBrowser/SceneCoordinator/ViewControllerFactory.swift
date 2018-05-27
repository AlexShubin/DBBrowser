//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class ViewControllerFactory {
    
    private let _stationSearchViewStateConverter: StationSearchViewStateConverter
    private var _appStateStore: StateStore!
    
    init(stationSearchViewStateConverter: StationSearchViewStateConverter) {
        _stationSearchViewStateConverter = stationSearchViewStateConverter
    }
    
    func setUp(appStateStore: StateStore) {
        _appStateStore = appStateStore
    }
    
    func make(_ scene: Scene) -> UIViewController {
        switch scene {
        case .mainScreen:
            let vc = MainScreenViewController()
            //vc.subscribe
            return vc
        case .stationSearch:
            let vc = StationSearchViewController(converter: _stationSearchViewStateConverter)
            vc.subscribe(to: _appStateStore)
            return vc
        }
    }
    
}
