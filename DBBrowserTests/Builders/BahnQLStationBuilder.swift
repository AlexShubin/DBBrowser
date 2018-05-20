//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class BahnQLStationBuilder {
    private var _name = TestData.stationName1
    private var _primaryEvaId: Int? = TestData.stationId1
    
    func with(name: String) -> BahnQLStationBuilder {
        _name = name
        return self
    }
    
    func with(primaryEvaId: Int?) -> BahnQLStationBuilder {
        _primaryEvaId = primaryEvaId
        return self
    }
    
    func build() -> SearchStationQuery.Data.Search.Station {
        return SearchStationQuery.Data.Search
            .Station(name: _name,
                     primaryEvaId: _primaryEvaId)
    }
}
