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

struct ApiStationFinder: StationFinder {

    private let _fahrplanService: FahrplanService
    private let _stationConverter: StationConverter

    init(fahrplanService: FahrplanService, stationConverter: StationConverter) {
        _fahrplanService = fahrplanService
        _stationConverter = stationConverter
    }

    func searchStation(namePart: String) -> Observable<StationFinderResult> {
        return _fahrplanService.searchStation(namePart: namePart)
            .map {
                .success($0.map {
                    self._stationConverter.convert(from: $0)
                })
            }
            .catchError { _ in
                .just(.error(.unknown))
        }
    }
}
