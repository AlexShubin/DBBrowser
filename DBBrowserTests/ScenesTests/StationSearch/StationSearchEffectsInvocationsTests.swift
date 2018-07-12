//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest
import RxTest
import RxSwift

class StationSearchEffectsInvocationsTests: XCTestCase {

    let stationSearchSideEffects = StationSearchSideEffectsMock()
    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()

    var stateStore: AppStateStore!
    var sideEffects: SideEffectsMock!

    override func setUp() {
        super.setUp()
        sideEffects = SideEffectsMock(sceneCoordinator: SceneCoordinatorSideEffectsMock(),
                                      stationSearch: stationSearchSideEffects,
                                      timetable: TimetableSideEffectsMock())
        stateStore = AppStateStore(sideEffects: sideEffects, scheduler: testScheduler)
    }

    func testLoadOrder() {
        let effectsObserver = testScheduler.createObserver(String.self)

        testScheduler.createColdObservable([
            Recorded.next(210, .stationSearch(.searchString("123"))),
            Recorded.next(220, .stationSearch(.startSearch))
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)

        stationSearchSideEffects.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)

        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus.asObservable()
        }

        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(220, "search")
            ])
    }

    func testSelectedStation() {
        let effectsObserver = testScheduler.createObserver(String.self)

        testScheduler.createColdObservable([
            Recorded.next(210, .stationSearch(.found(.success([StationBuilder().build()])))),
            Recorded.next(220, .stationSearch(.selected(0)))
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)

        stationSearchSideEffects.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)

        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus.asObservable()
        }

        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(220, "selectStation")
            ])
    }
}
