//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback
import Foundation

protocol SceneCoordinatorSideEffectsType: FeedbackLoopsHolder {
    var show: (Scene, PresentationStyle) -> Observable<AppEvent> { get }
    var close: (PresentationStyle) -> Observable<AppEvent> { get }
}

extension SceneCoordinatorSideEffectsType {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.coordinator.queryShow }, effects: show),
            react(query: { $0.coordinator.queryClose }, effects: close)
        ]
    }
}

struct SceneCoordinatorSideEffects: SceneCoordinatorSideEffectsType {
    private let _coordinator: SceneCoordinatorType

    init(coordinator: SceneCoordinatorType) {
        _coordinator = coordinator
    }

    var show: (Scene, PresentationStyle) -> Observable<AppEvent> {
        return { scene, style in
            switch style {
            case .modal:
                return self._coordinator.present(scene: scene).map { .coordinator(.shown) }
            case .push:
                return self._coordinator.push(scene: scene).map { .coordinator(.shown) }
            }
        }
    }

    var close: (PresentationStyle) -> Observable<AppEvent> {
        return { style in
            switch style {
            case .modal:
                return self._coordinator.dismiss().map { .coordinator(.closed) }
            case .push:
                return self._coordinator.pop().map { .coordinator(.closed) }
            }
        }
    }
}
