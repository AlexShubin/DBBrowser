//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback

protocol StationSearchSideEffectsType: FeedbackLoopsHolder {
    func search(by namePart: String) -> Observable<AppEvent>
}

extension StationSearchSideEffectsType {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.stationSearch.querySearch }, effects: search)
        ]
    }
}

struct StationSearchSideEffects: StationSearchSideEffectsType {
    
    private let _stationFinder: StationFinder
    private let _coordinator: Coordinator
    
    init(coordinator: Coordinator,
         stationFinder: StationFinder) {
        _coordinator = coordinator
        _stationFinder = stationFinder
    }
    
    func search(by namePart: String) -> Observable<AppEvent> {
        return _stationFinder.searchStation(namePart: namePart)
            .map { .stationSearch(.found($0)) }
    }
}
