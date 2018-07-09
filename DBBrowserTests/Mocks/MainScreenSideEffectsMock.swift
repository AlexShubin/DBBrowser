//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

struct MainScreenSideEffectsMock: MainScreenSideEffectsType {
    var openStationSearch: () -> Observable<AppEvent> {
        return {
            self.effects.onNext(#function)
            return .empty()
        }
    }

    let effects = PublishSubject<String>()
}
