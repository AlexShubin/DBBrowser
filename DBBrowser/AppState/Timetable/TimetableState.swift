//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

// MARK: - State
struct TimetableState: State, Equatable {
    typealias Event = TimetableEvent
    static let initial = TimetableState()

    enum Table: Int {
        case departures = 0
        case arrivals = 1
    }

    var timetableResult: TimetableLoaderResult = .success(Timetable(arrivals: [], departures: []))
    var shouldLoadTimetable = false

    var currentTable = Table.departures

    var station: Station?
    var date = Date()
}

// MARK: - Events
enum TimetableEvent {
    case station(Station)
    case loadTimetable
    case timetableLoaded(TimetableLoaderResult)
    case changeTable(Int)
}

// MARK: - Queries
extension TimetableState {
    var queryLoadTimetable: TimetableLoadParams? {
        guard shouldLoadTimetable,
            let station = station else {
            return nil
        }
        return TimetableLoadParams(station: station, date: date)
    }
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
            result.shouldLoadTimetable = false
        case .changeTable(let tableIndex):
            result.currentTable = Table(rawValue: tableIndex) ?? .departures
        }
        return result
    }
}
