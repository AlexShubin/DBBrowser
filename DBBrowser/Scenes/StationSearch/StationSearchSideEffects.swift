//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback
import Foundation

protocol StationSearchSideEffectsType: FeedbackLoopsHolder {
    var search: (String) -> Observable<AppEvent> { get }
    var selectStation: (Station) -> Observable<AppEvent> { get }
    var close: () -> Observable<AppEvent> { get }
}

extension StationSearchSideEffectsType {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.stationSearch.querySearch }, effects: search),
            react(query: { $0.stationSearch.querySelectedStation }, effects: selectStation),
            react(query: { $0.stationSearch.queryClose }, effects: close)
        ]
    }
}

struct StationSearchSideEffects: StationSearchSideEffectsType {

    private let _stationFinder: StationFinder
    private let _coordinator: SceneCoordinatorType

    init(coordinator: SceneCoordinatorType,
         stationFinder: StationFinder) {
        _coordinator = coordinator
        _stationFinder = stationFinder
    }

    var search: (String) -> Observable<AppEvent> {
        return {
            self._stationFinder.searchStation(namePart: $0)
                .map { .stationSearch(.found($0)) }
        }
    }

    var selectStation: (Station) -> Observable<AppEvent> {
        return {
            .of(.mainScreen(.departure($0)),
                .stationSearch(.close))
        }
    }

    var close: () -> Observable<AppEvent> {
        return {
            self._coordinator.dismiss()
                .map { .stationSearch(.closed) }
        }
    }
}
