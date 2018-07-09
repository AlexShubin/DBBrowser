//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import SWXMLHash

protocol TimeTableDecoder {
    func decode(_ data: Data) throws -> ApiTimetable
}

enum TimeTableDecoderError: Error {
    case decodingError
}

struct XMLTimeTableDecoder {
    func decode(_ data: Data) throws -> ApiTimetable {
        let xml = SWXMLHash.parse(data)
        let stops: [ApiStop] = try xml["timetable"]["s"].all.map {
            guard let xmlTl = $0["tl"].element,
                let category = xmlTl.attribute(by: "c")?.text,
                let number = xmlTl.attribute(by: "n")?.text else {
                    throw TimeTableDecoderError.decodingError
            }
            let tripLabel = ApiTripLabel(category: category, number: number)
            return ApiStop(tripLabel: tripLabel,
                           arrival: try _decode($0["ar"].element),
                           departure: try _decode($0["dp"].element))
        }
        return ApiTimetable(stops: stops)
    }

    private func _decode(_ event: XMLElement?) throws -> ApiEvent? {
        guard let xmlEvent = event else {
            return nil
        }
        guard let platform = xmlEvent.attribute(by: "pp")?.text,
            let time = xmlEvent.attribute(by: "pt")?.text,
            let path = xmlEvent.attribute(by: "ppth")?.text else {
                throw TimeTableDecoderError.decodingError
        }
        return ApiEvent(platform: platform, time: time, path: path)
    }
}
