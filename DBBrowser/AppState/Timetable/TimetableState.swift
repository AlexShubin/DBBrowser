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

    enum LoadingState {
        case error, success, loading
    }

    var timetable = Timetable(arrivals: [], departures: [])
    var loadingState = LoadingState.success

    var currentTable = Table.departures

    var station: Station?
    var dateToLoad = Date()
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
        guard case .loading = loadingState,
            let station = station else {
            return nil
        }
        return TimetableLoadParams(station: station, date: dateToLoad)
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
            result.loadingState = .loading
        case .timetableLoaded(let timetableResult):
            switch timetableResult {
            case .success(let timetable):
                result.timetable += timetable
                result.loadingState = .success
                result.dateToLoad = state.dateToLoad.startOfTheNextHour
            case .error:
                result.loadingState = .error
            }
        case .changeTable(let tableIndex):
            result.currentTable = Table(rawValue: tableIndex) ?? .departures
        }
        return result
    }
}
