//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback
import Foundation

protocol TimetableSideEffectsType: FeedbackLoopsHolder {
    var loadTimetable: (TimetableLoadParams) -> Observable<AppEvent> { get }
}

extension TimetableSideEffectsType {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.timetable.queryLoadTimetable }, effects: loadTimetable)
        ]
    }
}

struct TimetableSideEffects: TimetableSideEffectsType {

    private let _timetableLoader: TimetableLoader
    private let _changesLoader: ChangesLoader

    init(timetableLoader: TimetableLoader, changesLoader: ChangesLoader) {
        _timetableLoader = timetableLoader
        _changesLoader = changesLoader
    }

    var loadTimetable: (TimetableLoadParams) -> Observable<AppEvent> {
        return {
            if $0.shouldLoadChanges {
                return Observable.combineLatest(
                    self._timetableLoader.load(evaId: $0.station.evaId, date: $0.date, corrStation: $0.corrStation),
                    self._changesLoader.load(evaId: $0.station.evaId)) {
                        switch ($0, $1) {
                        case (.success(let timetable), .success(let changes)):
                            return .of(.timetable(.changesLoaded(changes)),
                                       .timetable(.timetableLoaded(timetable)))
                        case (.error, _), (_, .error):
                            return .just(.timetable(.timetableLoadingError))
                        }
                    }
                    .flatMap { appEvets -> Observable<AppEvent> in appEvets }
            } else {
                return self._timetableLoader.load(evaId: $0.station.evaId, date: $0.date, corrStation: $0.corrStation)
                    .map {
                        switch $0 {
                        case .success(let timetable):
                            return .timetable(.timetableLoaded(timetable))
                        case .error:
                            return.timetable(.timetableLoadingError)
                        }
                }
            }
        }
    }
}
