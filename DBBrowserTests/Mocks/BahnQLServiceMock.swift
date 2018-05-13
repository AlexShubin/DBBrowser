//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

final class BahnQLServiceMock: BahnQLService {
    let invocations = PublishSubject<String>()
    var expected = [SearchStationQuery.Data.Search.Station]()
    
    func searchStation(namePart: String) -> Observable<[SearchStationQuery.Data.Search.Station]> {
        invocations.onNext(#function)
        return .of(expected)
    }
}
