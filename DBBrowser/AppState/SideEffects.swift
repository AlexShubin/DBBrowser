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
    var mainScreen: MainScreenSideEffectsType { get }
    var timetable: TimetableSideEffectsType { get }
}

extension SideEffects {
    var feedbackLoops: [FeedbackLoop] {
        return stationSearch.feedbackLoops
            + mainScreen.feedbackLoops
            + timetable.feedbackLoops
    }
}

struct AppSideEffects: SideEffects {

    let stationSearch: StationSearchSideEffectsType
    let mainScreen: MainScreenSideEffectsType
    let timetable: TimetableSideEffectsType

    init(coordinator: SceneCoordinatorType,
         stationFinder: StationFinder,
         timetableLoader: TimetableLoader) {
        stationSearch = StationSearchSideEffects(coordinator: coordinator,
                                                 stationFinder: stationFinder)
        mainScreen = MainScreenSideEffects(coordinator: coordinator)
        timetable = TimetableSideEffects(timetableLoader: timetableLoader)
    }
}
