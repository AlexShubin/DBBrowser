//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest
import RxTest
import RxSwift

class MainScreenEffectsInvocationsTests: XCTestCase {

    let mainScreenSideEffects = MainScreenSideEffectsMock()
    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()

    var stateStore: AppStateStore!
    var sideEffects: SideEffectsMock!

    override func setUp() {
        super.setUp()
        sideEffects = SideEffectsMock(mainScreen: mainScreenSideEffects,
                                      stationSearch: StationSearchSideEffectsMock())
        stateStore = AppStateStore(sideEffects: sideEffects, scheduler: testScheduler)
    }

    func testOpenStationSearch() {
        let effectsObserver = testScheduler.createObserver(String.self)

        testScheduler.createColdObservable([
            Recorded.next(210, .mainScreen(.openStationSearch))
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)

        mainScreenSideEffects.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)

        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus.asObservable()
        }

        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(210, "openStationSearch")
            ])
    }
}
