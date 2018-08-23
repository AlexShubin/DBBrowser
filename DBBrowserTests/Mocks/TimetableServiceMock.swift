//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

class TimetableServiceMock: TimetablesService {
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
    var expectedChanges = Observable.just(ApiChanges(stops: []))
}
