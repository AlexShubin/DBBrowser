//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class StationBuilder {
    private var _name = TestData.stationName1
    private var _evaId = TestData.stationId1
    
    func with(name: String) -> StationBuilder {
        _name = name
        return self
    }
    
    func with(evaId: Int) -> StationBuilder {
        _evaId = evaId
        return self
    }
    
    func build() -> Station {
        return Station(name: _name,
                       evaId: _evaId)
    }
}
