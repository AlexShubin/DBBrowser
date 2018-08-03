//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest
import RxTest
import RxSwift

class TimetableEffectsInvocationsTests: XCTestCase {

    let timetableSideEffects = TimetableSideEffectsMock()
    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()

    var stateStore: AppStateStore!
    var sideEffects: SideEffectsMock!

    override func setUp() {
        super.setUp()
        sideEffects = SideEffectsMock(timetable: timetableSideEffects)
        stateStore = AppStateStore(sideEffects: sideEffects, scheduler: testScheduler)
    }

    func testLoadTimetable() {
        let effectsObserver = testScheduler.createObserver(String.self)

        let station = StationBuilder().build()
        testScheduler.createColdObservable([
            Recorded.next(210, .timetable(.station(station))),
            Recorded.next(220, .timetable(.loadTimetable))
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)

        timetableSideEffects.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)

        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus.asObservable()
        }

        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(220, "loadTimetable")
            ])
    }
}
