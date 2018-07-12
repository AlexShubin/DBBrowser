//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

struct SceneCoordinatorSideEffectsMock: SceneCoordinatorSideEffectsType {
    var show: (Scene, PresentationStyle) -> Observable<AppEvent> {
        return { _, _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }

    var close: (PresentationStyle) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }

    let effects = PublishSubject<String>()
}
