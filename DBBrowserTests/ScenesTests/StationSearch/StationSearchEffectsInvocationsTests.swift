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
        sideEffects = SideEffectsMock(stationSearch: stationSearchSideEffects)
        stateStore = AppStateStore(sideEffects: sideEffects, scheduler: testScheduler)
    }
    
    func testLoadOrder() {
        let effectsObserver = testScheduler.createObserver(String.self)

        testScheduler.createColdObservable([
            Recorded.next(210, .stationSearch(.search("123")))
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)

        stationSearchSideEffects.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)

        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus
                .map { $0.stationSearch }
                .asObservable()
        }

        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(210, "search(by:)")
            ])
    }
}
