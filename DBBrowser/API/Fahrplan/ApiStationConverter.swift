//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct ApiStationConverter {
    func convert(from apiStation: FahrplanStation) -> Station {
        return Station(name: apiStation.name,
                       evaId: apiStation.id)
    }
}
