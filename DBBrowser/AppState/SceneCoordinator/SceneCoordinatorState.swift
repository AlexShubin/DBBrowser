//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct SceneCoordinatorState: State {
    typealias Event = CoordinatorEvent
    static let initial = SceneCoordinatorState()

    var shouldShow: (Scene, PresentationStyle)?
    var shouldClose: PresentationStyle?
}

// MARK: - Events
enum CoordinatorEvent {
    case show(Scene, PresentationStyle)
    case shown
    case close(PresentationStyle)
    case closed
}

// MARK: - Queries
extension SceneCoordinatorState {
    var queryShow: (Scene, PresentationStyle)? {
        return shouldShow
    }
    var queryClose: PresentationStyle? {
        return shouldClose
    }
}

// MARK: - Reducer
extension SceneCoordinatorState {
    static func reduce(state: SceneCoordinatorState, event: CoordinatorEvent) -> SceneCoordinatorState {
        var result = state
        switch event {
        case .show(let scene, let style):
            result.shouldShow = (scene, style)
        case .close(let style):
            result.shouldClose = style
        case .closed:
            result.shouldClose = nil
        case .shown:
            result.shouldShow = nil
        }
        return result
    }
}
