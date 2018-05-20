//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback

typealias ScheduledSideEffect = (ObservableSchedulerContext<AppState>) -> Observable<AppEvent>

protocol BaseSideEffects {
    var effects: [ScheduledSideEffect] { get }
}

protocol SideEffects: BaseSideEffects {
    var stationSearch: StationSearchSideEffectsType { get }
}

extension SideEffects {
    var effects: [ScheduledSideEffect] {
        return stationSearch.effects
    }
}

struct AppSideEffects: SideEffects {
    
    let stationSearch: StationSearchSideEffectsType
    
    init(coordinator: Coordinator,
         stationFinder: StationFinder) {
        stationSearch = StationSearchSideEffects(coordinator: coordinator,
                                                 stationFinder: stationFinder)
    }
}
