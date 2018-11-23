//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import DBAPI
import RxSwift

class TimetableServiceMock: TimetablesService {
    func station(evaNo: Int) -> Observable<[ApiStationInfo]> {
        invocations.onNext(#function)
        return expectedStationInfo
    }

    func loadChanges(evaNo: Int) -> Observable<ApiChanges> {
        invocations.onNext(#function)
        return expectedChanges
    }

    func loadTimetable(evaNo: Int, date: String, hour: String) -> Observable<ApiTimetable> {
        invocations.onNext(#function)
        return expectedTimetable
    }

    let invocations = PublishSubject<String>()
    var expectedTimetable = Observable.just(ApiTimetableBuilder().build())
    var expectedChanges = Observable.just(ApiChanges.empty)
    var expectedStationInfo = Observable.just([ApiStationInfo]())
}
