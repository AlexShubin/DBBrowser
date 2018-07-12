//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

struct SideEffectsMock: SideEffects {
    var sceneCoordinator: SceneCoordinatorSideEffectsType
    var stationSearch: StationSearchSideEffectsType
    var timetable: TimetableSideEffectsType
}
