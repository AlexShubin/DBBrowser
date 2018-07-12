//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback
import Foundation

protocol TimetableSideEffectsType: FeedbackLoopsHolder {
    var loadTimetable: (TimetableLoadParams) -> Observable<AppEvent> { get }
}

extension TimetableSideEffectsType {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.timetable.queryLoadTimetable }, effects: loadTimetable)
        ]
    }
}

struct TimetableSideEffects: TimetableSideEffectsType {

    private let _timetableLoader: TimetableLoader

    init(timetableLoader: TimetableLoader) {
        _timetableLoader = timetableLoader
    }

    var loadTimetable: (TimetableLoadParams) -> Observable<AppEvent> {
        return {
            self._timetableLoader.load(with: $0)
                .map { .timetable(.timetableLoaded($0)) }
        }
    }
}
