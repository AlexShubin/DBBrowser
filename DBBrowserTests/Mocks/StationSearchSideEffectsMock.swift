//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

struct StationSearchSideEffectsMock: StationSearchSideEffectsType {
    var selectStation: (Station) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }
    
    var search: (String) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }
    
    let effects = PublishSubject<String>()
}
