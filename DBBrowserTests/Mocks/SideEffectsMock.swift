//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

struct SideEffectsMock: SideEffects {
    var sceneCoordinator: SceneCoordinatorSideEffectsType
    var stationSearch: StationSearchSideEffectsType
    var timetable: TimetableSideEffectsType

    init(sceneCoordinator: SceneCoordinatorSideEffectsType = SceneCoordinatorSideEffectsMock(),
         stationSearch: StationSearchSideEffectsType = StationSearchSideEffectsMock(),
         timetable: TimetableSideEffectsType = TimetableSideEffectsMock()) {
        self.sceneCoordinator = sceneCoordinator
        self.stationSearch = stationSearch
        self.timetable = timetable
    }
}
