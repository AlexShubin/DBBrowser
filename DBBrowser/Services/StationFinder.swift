//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift

typealias StationFinderResult = Result<[Station], StationFinderError>

protocol StationFinder {
    func searchStation(namePart: String) -> Observable<StationFinderResult>
}

enum StationFinderError: String, Error, Equatable {
    case unknown
}

struct BahnQLStationFinder: StationFinder {
    
    private let _bahnQLService: BahnQLService
    private let _stationConverter: StationConverter
    
    init(bahnQLService: BahnQLService, stationConverter: StationConverter) {
        _bahnQLService = bahnQLService
        _stationConverter = stationConverter
    }
    
    func searchStation(namePart: String) -> Observable<StationFinderResult> {
        return _bahnQLService.searchStation(namePart: namePart)
            .map {
                .success($0.filter { $0.primaryEvaId != nil }.map {
                    self._stationConverter.convert(from: $0)
                })
            }
            .catchError { _ in
                .just(.error(.unknown))
        }
    }
}
