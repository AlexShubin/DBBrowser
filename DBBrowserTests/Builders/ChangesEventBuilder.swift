//
//  ChangesEventBuilder.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation

final class ChangesEventBuilder {
    var stations: [String]?
    var time: Date?
    var platform: String?
    var id = TestData.Timetable.id1
    var isCanceled: Bool = false

    init(builder: (ChangesEventBuilder) -> Void = { _ in }) {
        builder(self)
    }

    func build() -> Changes.Event {
        return Changes.Event(id: id,
                             stations: stations,
                             time: time,
                             platform: platform,
                             isCanceled: isCanceled)
    }
}
