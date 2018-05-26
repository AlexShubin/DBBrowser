//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback

typealias FeedbackLoop = (ObservableSchedulerContext<AppState>) -> Observable<AppEvent>

protocol FeedbackLoopsHolder {
    var feedbackLoops: [FeedbackLoop] { get }
}

protocol SideEffects: FeedbackLoopsHolder {
    var stationSearch: StationSearchSideEffectsType { get }
}

extension SideEffects {
    var feedbackLoops: [FeedbackLoop] {
        return stationSearch.feedbackLoops
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
