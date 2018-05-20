//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

struct StationSearchSideEffectsMock: StationSearchSideEffectsType {
    let effects = PublishSubject<String>()
    func search(by namePart: String) -> Observable<AppEvent> {
        effects.onNext(#function)
        return .empty()
    }
}
