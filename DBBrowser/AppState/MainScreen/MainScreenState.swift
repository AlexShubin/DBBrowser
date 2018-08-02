//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

// MARK: - State
struct MainScreenState: State, Equatable {
    typealias Event = MainScreenEvent
    static let initial = MainScreenState()

    var date = Date()
    var shouldOpenTimetable = false
}

// MARK: - Events
enum MainScreenEvent {
    case date(Date)
    case openTimetable
    case timetableOpened
}

// MARK: - Queries
extension MainScreenState {
    var queryOpenTimetable: Date? {
        return shouldOpenTimetable ? date : nil
    }
}

// MARK: - Reducer
extension MainScreenState {
    static func reduce(state: MainScreenState, event: MainScreenEvent) -> MainScreenState {
        var result = state
        switch event {
        case .date(let date):
            result.date = date
        case .openTimetable:
            result.shouldOpenTimetable = true
        case .timetableOpened:
            result.shouldOpenTimetable = false
        }
        return result
    }
}
