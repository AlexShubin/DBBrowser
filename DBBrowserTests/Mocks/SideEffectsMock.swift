//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

struct SideEffectsMock: SideEffects {
    var mainScreen: MainScreenSideEffectsType
    var sceneCoordinator: SceneCoordinatorSideEffectsType
    var stationSearch: StationSearchSideEffectsType
    var timetable: TimetableSideEffectsType

    init(mainScreen: MainScreenSideEffectsType = MainScreenSideEffectsMock(),
         sceneCoordinator: SceneCoordinatorSideEffectsType = SceneCoordinatorSideEffectsMock(),
         stationSearch: StationSearchSideEffectsType = StationSearchSideEffectsMock(),
         timetable: TimetableSideEffectsType = TimetableSideEffectsMock()) {
        self.mainScreen = mainScreen
        self.sceneCoordinator = sceneCoordinator
        self.stationSearch = stationSearch
        self.timetable = timetable
    }
}
