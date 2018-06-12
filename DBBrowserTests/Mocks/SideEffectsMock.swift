//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

struct SideEffectsMock: SideEffects {
    var mainScreen: MainScreenSideEffectsType
    var stationSearch: StationSearchSideEffectsType
}
