//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback
import Foundation

protocol TimetableSideEffectsType: FeedbackLoopsHolder {
    var loadTimetable: (TimetableLoadParams) -> Observable<AppEvent> { get }
    var loadStationInfo: (Station) -> Observable<AppEvent> { get }
}

extension TimetableSideEffectsType {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.timetable.queryLoadTimetable }, effects: loadTimetable),
            react(query: { $0.timetable.queryLoadStationInfo }, effects: loadStationInfo)
        ]
    }
}

struct TimetableSideEffects: TimetableSideEffectsType {

    private let _timetableLoader: TimetableLoader
    private let _changesLoader: ChangesLoader
    private let _stationInfoLoader: StationInfoLoader

    init(timetableLoader: TimetableLoader, changesLoader: ChangesLoader, stationInfoLoader: StationInfoLoader) {
        _timetableLoader = timetableLoader
        _changesLoader = changesLoader
        _stationInfoLoader = stationInfoLoader
    }

    var loadStationInfo: (Station) -> Observable<AppEvent> {
        return {
            return self._stationInfoLoader.load(evaId: $0.evaId)
                .map { .timetable(.stationInfoLoaded($0)) }
                .catchError { _ in .just(.timetable(.timetableLoadingError)) }
        }
    }

    var loadTimetable: (TimetableLoadParams) -> Observable<AppEvent> {
        return { params in
            if params.shouldLoadChanges {
                return Observable.combineLatest(
                    self._changesLoader.load(evaId: params.station.evaId,
                                             metaEvaIds: params.stationInfo.metaStationsIds),
                    self._timetableLoader.load(evaId: params.station.evaId,
                                               metaEvaIds: params.stationInfo.metaStationsIds,
                                               date: params.date,
                                               corrStation: params.corrStation)) {
                        return .of(.timetable(.changesLoaded($0)),
                                   .timetable(.timetableLoaded($1)))
                    }
                    .flatMap { appEvets -> Observable<AppEvent> in appEvets }
                    .catchError { _ in .just(.timetable(.timetableLoadingError)) }
            } else {
                return self._timetableLoader.load(evaId: params.station.evaId,
                                                  metaEvaIds: params.stationInfo.metaStationsIds,
                                                  date: params.date,
                                                  corrStation: params.corrStation)
                    .map { .timetable(.timetableLoaded($0)) }
                    .catchError { _ in .just(.timetable(.timetableLoadingError)) }
            }
        }
    }
}
