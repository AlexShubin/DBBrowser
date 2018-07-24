//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct StationConverter: Converter {
    func convert(from input: FahrplanStation) -> Station {
        return Station(name: input.name,
                       evaId: input.id)
    }
}
