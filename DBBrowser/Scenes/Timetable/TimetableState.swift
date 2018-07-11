//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct TimetableState: State, Equatable {
    typealias Event = TimetableEvent
    static let initial = TimetableState()
    
    var timetableResult: TimetableLoaderResult = .success(Timetable(arrivals: [], departures: []))
    var shouldLoadTimetable = false
    var station: Station?
//    var shouldClose = false
}

// MARK: - Events
enum TimetableEvent {
    case station(Station)
    case loadTimetable
    case timetableLoaded(TimetableLoaderResult)
    case close
    case closed
}

// MARK: - Queries
extension TimetableState {
    
}

// MARK: - Reducer
extension TimetableState {
    static func reduce(state: TimetableState, event: TimetableEvent) -> TimetableState {
        var result = state
        switch event {
        case .station(let station):
            result.station = station
        case .loadTimetable:
            result.shouldLoadTimetable = true
        case .timetableLoaded(let timetableResult):
            result.timetableResult = timetableResult
        case .close:
            break
        case .closed:
            break
        }
        return result
    }
}
