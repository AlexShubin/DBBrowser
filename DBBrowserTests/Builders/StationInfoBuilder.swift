//
//  StationInfoBuilder.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 24/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class StationInfoBuilder {
    var metaStationsIds = Set<Int>()

    init(builder: (StationInfoBuilder) -> Void = { _ in }) {
        builder(self)
    }

    func build() -> StationInfo {
        return StationInfo(metaStationsIds: metaStationsIds)
    }
}
