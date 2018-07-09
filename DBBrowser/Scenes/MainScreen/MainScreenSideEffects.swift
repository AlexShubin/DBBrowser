//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback
import Foundation

protocol MainScreenSideEffectsType: FeedbackLoopsHolder {
    var openStationSearch:() -> Observable<AppEvent> { get }
}

extension MainScreenSideEffectsType {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.mainScreen.queryOpenStationSearch }, effects: openStationSearch)
        ]
    }
}

struct MainScreenSideEffects: MainScreenSideEffectsType {

    private let _coordinator: Coordinator

    init(coordinator: Coordinator) {
        _coordinator = coordinator
    }

    var openStationSearch:() -> Observable<AppEvent> {
        return {
            self._coordinator.transition(to: .stationSearch, type: .modal)
                .map { .mainScreen(.stationSearchOpened) }
        }
    }
}
