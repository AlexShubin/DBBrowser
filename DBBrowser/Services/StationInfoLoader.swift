//
//  StationInfoLoader.swift
//  DBBrowser
//
//  Created by Alex Shubin on 24/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import DBAPI

protocol StationInfoLoader {
    func load(evaId: Int) -> Observable<StationInfo>
}

struct ApiStationInfoLoader: StationInfoLoader {
    private let _timetableService: TimetablesService
    private let _stationInfoConverter: StationInfoConverter

    init(timetableService: TimetablesService,
         stationInfoConverter: StationInfoConverter) {
        _timetableService = timetableService
        _stationInfoConverter = stationInfoConverter
    }

    func load(evaId: Int) -> Observable<StationInfo> {
        return _timetableService.station(evaNo: evaId).map {
            guard let apiInfo = $0.first else {
                return StationInfo.empty
            }
            return try self._stationInfoConverter.convert(from: apiInfo)
        }
    }
}
