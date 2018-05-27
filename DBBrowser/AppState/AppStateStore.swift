//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback

protocol StateStore {
    var eventBus: PublishRelay<AppEvent> { get }
    var stateBus: Signal<AppState> { get }
    func run()
}

struct AppStateStore: StateStore {
    
    let eventBus: PublishRelay<AppEvent>
    let stateBus: Signal<AppState>
    
    init(sideEffects: SideEffects, scheduler: SchedulerType = MainScheduler.instance) {
        
        let _eventBus = PublishRelay<AppEvent>()
        eventBus = _eventBus
        let eventBusFeedback: FeedbackLoop = { _ -> Observable<AppEvent> in
            _eventBus.asObservable()
        }
        
        var feedBacks = sideEffects.feedbackLoops
        feedBacks.append(eventBusFeedback)
        
        stateBus = Observable.system(initialState: AppState.initial,
                                     reduce: AppState.reduce,
                                     scheduler: scheduler,
                                     scheduledFeedback: feedBacks)
            .do(onError: { fatalError("Impossible happened: \($0.localizedDescription)")
            }, onCompleted: { fatalError("Impossible happened: System observable completed") })
            .asSignal(onErrorSignalWith: .never())
    }
    
    func run() {
        _ = stateBus.emit()
    }
}
