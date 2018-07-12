//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct TimetableState: State, Equatable {
    typealias Event = TimetableEvent
    static let initial = TimetableState()

    var timetableResult: TimetableLoaderResult = .success(Timetable(arrivals: [], departures: []))
    var shouldLoadTimetable = false
    var timetableLoadParams: TimetableLoadParams?
}

// MARK: - Events
enum TimetableEvent {
    case timetableLoadParams(TimetableLoadParams)
    case loadTimetable
    case timetableLoaded(TimetableLoaderResult)
}

// MARK: - Queries
extension TimetableState {

}

// MARK: - Reducer
extension TimetableState {
    static func reduce(state: TimetableState, event: TimetableEvent) -> TimetableState {
        var result = state
        switch event {
        case .timetableLoadParams(let params):
            result.timetableLoadParams = params
        case .loadTimetable:
            result.shouldLoadTimetable = true
        case .timetableLoaded(let timetableResult):
            result.timetableResult = timetableResult
        }
        return result
    }
}
