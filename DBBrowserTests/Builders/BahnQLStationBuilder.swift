//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class FahrplanStationBuilder {
    private var _name = TestData.stationName1
    private var _id = TestData.stationId1
    
    func with(name: String) -> FahrplanStationBuilder {
        _name = name
        return self
    }
    
    func with(id: Int) -> FahrplanStationBuilder {
        _id = id
        return self
    }
    
    func build() -> FahrplanStation {
        return FahrplanStation(name: _name, id: _id)
    }
}
