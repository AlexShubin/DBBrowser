//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

// MARK: - State
struct MainScreenState: State, Equatable {
    typealias Event = MainScreenEvent
    static let initial = MainScreenState()
}

// MARK: - Events
enum MainScreenEvent {

}

// MARK: - Queries
extension MainScreenState {

}

// MARK: - Reducer
extension MainScreenState {
    static func reduce(state: MainScreenState, event: MainScreenEvent) -> MainScreenState {
        let result = state
//        switch event {
//        }
        return result
    }
}
