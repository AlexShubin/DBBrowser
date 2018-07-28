//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

// MARK: - State
struct MainScreenState: State, Equatable {
    typealias Event = MainScreenEvent
    static let initial = MainScreenState()

    var station: Station?
    var date = Date()
}

// MARK: - Events
enum MainScreenEvent {
    case station(Station)
}

// MARK: - Queries
extension MainScreenState {

}

// MARK: - Reducer
extension MainScreenState {
    static func reduce(state: MainScreenState, event: MainScreenEvent) -> MainScreenState {
        var result = state
        switch event {
        case .station(let station):
            result.station = station
        }
        return result
    }
}
