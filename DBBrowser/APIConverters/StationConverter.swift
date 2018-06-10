//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

protocol StationConverter {
    func convert(from apiStation: FahrplanStation) -> Station
}

struct ApiStationConverter: StationConverter {
    func convert(from apiStation: FahrplanStation) -> Station {
        return Station(name: apiStation.name,
                       evaId: apiStation.id)
    }
}
