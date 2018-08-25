//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

struct TimetableSideEffectsMock: TimetableSideEffectsType {
    var loadStationInfo: (Station) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }

    var loadTimetable: (TimetableLoadParams) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }

    let effects = PublishSubject<String>()
}
