//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

struct MainScreenSideEffectsMock: MainScreenSideEffectsType {
    var openTimetable: (Date) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }

    let effects = PublishSubject<String>()
}
