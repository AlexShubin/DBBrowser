//
//  StationInfo.swift
//  DBBrowser
//
//  Created by Alex Shubin on 23/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct StationInfo: Equatable {
    let metaStationsIds: Set<Int>

    static let empty = StationInfo(metaStationsIds: [])
}
