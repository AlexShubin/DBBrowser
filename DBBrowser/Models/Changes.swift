//
//  Changes.swift
//  DBBrowser
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

struct Changes: Equatable {
    struct Event: Equatable {
        let id: String
        let stations: [String]?
        let time: Date?
        let platform: String?
        let isCanceled: Bool
    }
    var arrivals: [Event]
    var departures: [Event]

    static let empty = Changes(arrivals: [], departures: [])
}
