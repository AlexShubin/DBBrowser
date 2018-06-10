//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

final class FahrplanServiceMock: FahrplanService {
    let invocations = PublishSubject<String>()
    var expected = Observable.just([FahrplanStation]())
    
    func searchStation(namePart: String) -> Observable<[FahrplanStation]> {
        invocations.onNext(#function)
        return expected
    }
}
