//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class StationBuilder {
    var name = TestData.stationName1
    var evaId = TestData.stationId1

    init(builder: (StationBuilder) -> Void = { _ in }) {
        builder(self)
    }

    func build() -> Station {
        return Station(name: name, evaId: evaId)
    }
}
