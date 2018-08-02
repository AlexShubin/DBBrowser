//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback
import Foundation

protocol MainScreenSideEffectsType: FeedbackLoopsHolder {
    var openTimetable: (Date) -> Observable<AppEvent> { get }
}

extension MainScreenSideEffectsType {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.mainScreen.queryOpenTimetable }, effects: openTimetable)
        ]
    }
}

struct MainScreenSideEffects: MainScreenSideEffectsType {

    var openTimetable: (Date) -> Observable<AppEvent> {
        return {
            .of(
                .timetable(.cleanUp),
                .timetable(.dateToLoad($0)),
                .coordinator(.show( .timetable, .push)),
                .mainScreen(.timetableOpened)
            )
        }
    }
}
