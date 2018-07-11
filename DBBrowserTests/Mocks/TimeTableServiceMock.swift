//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import RxSwift

class TimeTableServiceMock: TimetableService {
    func loadTimetable(evaNo: String, date: String, hour: String) -> Observable<ApiTimetable> {
        invocations.onNext(#function)
        return expected
    }

    let invocations = PublishSubject<String>()
    var expected = Observable.just(ApiTimetable(stops: []))
}
