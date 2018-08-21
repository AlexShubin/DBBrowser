//
//  ChangesBuilder.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class ChangesBuilder {
    var arrivals = [Changes.Event]()
    var departures = [Changes.Event]()

    init(builder: (ChangesBuilder) -> Void = { _ in }) {
        builder(self)
    }

    func build() -> Changes {
        return Changes(arrivals: arrivals, departures: departures)
    }
}
