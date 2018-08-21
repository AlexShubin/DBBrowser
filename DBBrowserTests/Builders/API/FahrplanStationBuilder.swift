//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class FahrplanStationBuilder {
    var name = TestData.stationName1
    var id = TestData.stationId1

    init(builder: (FahrplanStationBuilder) -> Void = { _ in }) {
        builder(self)
    }

    func build() -> FahrplanStation {
        return FahrplanStation(name: name, id: id)
    }
}
