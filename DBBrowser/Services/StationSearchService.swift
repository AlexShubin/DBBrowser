//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift

protocol StationSearchService {
    func searchStation(namePart: String) -> Observable<[Station]>
}

struct BahnQLStationSearchService: StationSearchService {
    
    private let _bahnQLService: BahnQLService
    private let _stationConverter: StationConverter
    
    init(bahnQLService: BahnQLService, stationConverter: StationConverter) {
        _bahnQLService = bahnQLService
        _stationConverter = stationConverter
    }
    
    func searchStation(namePart: String) -> Observable<[Station]> {
        return _bahnQLService.searchStation(namePart: namePart)
            .map { $0.map { self._stationConverter.convert(from: $0) } }
    }
}
