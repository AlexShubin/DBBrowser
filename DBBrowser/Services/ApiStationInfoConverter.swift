//
//  ApiStationInfoConverter.swift
//  DBBrowser
//
//  Created by Alex Shubin on 23/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import DBAPI

protocol StationInfoConverter {
    func convert(from apiStationInfo: ApiStationInfo) throws -> StationInfo
}

enum StationInfoConverterError: String, Error, Equatable {
    case wrongEvaIdFormat
}

struct ApiStationInfoConverter: StationInfoConverter {
    func convert(from apiStationInfo: ApiStationInfo) throws -> StationInfo {
        let ids: [Int] = try apiStationInfo.meta?.components(separatedBy: "|").map {
            guard let evaId = Int($0) else {
                throw StationInfoConverterError.wrongEvaIdFormat
            }
            return evaId
            } ?? []
        return StationInfo(metaStationsIds: Set(ids))
    }
}
