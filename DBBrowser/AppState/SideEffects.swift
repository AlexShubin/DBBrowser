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
    var timetable: TimetableSideEffectsType { get }
    var sceneCoordinator: SceneCoordinatorSideEffectsType { get }
    var mainScreen: MainScreenSideEffectsType { get }
}

extension SideEffects {
    var feedbackLoops: [FeedbackLoop] {
        return stationSearch.feedbackLoops
            + timetable.feedbackLoops
            + sceneCoordinator.feedbackLoops
            + mainScreen.feedbackLoops
    }
}

struct AppSideEffects: SideEffects {

    let stationSearch: StationSearchSideEffectsType
    let timetable: TimetableSideEffectsType
    let sceneCoordinator: SceneCoordinatorSideEffectsType
    let mainScreen: MainScreenSideEffectsType

    init(coordinator: SceneCoordinatorType,
         stationFinder: StationFinder,
         timetableLoader: TimetableLoader) {
        stationSearch = StationSearchSideEffects(stationFinder: stationFinder)
        timetable = TimetableSideEffects(timetableLoader: timetableLoader)
        sceneCoordinator = SceneCoordinatorSideEffects(coordinator: coordinator)
        mainScreen = MainScreenSideEffects()
    }
}
