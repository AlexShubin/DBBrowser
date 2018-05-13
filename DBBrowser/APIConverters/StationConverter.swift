//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

protocol StationConverter {
    func convert(from apiStation: SearchStationQuery.Data.Search.Station) -> Station
}

struct ApiStationConverter: StationConverter {
    func convert(from apiStation: SearchStationQuery.Data.Search.Station) -> Station {
        guard let evaId = apiStation.primaryEvaId else {
            fatalError("No evaId on station: \(apiStation)")
        }
        return Station(name: apiStation.name,
                       evaId: evaId)
    }
}
