//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import SWXMLHash

enum TimetablesDecoderError: Error {
    case decodingError
}

struct XMLTimetablesDecoder {

    // MARK: - Timetable decoder

    func decodeTimetable(_ data: Data) throws -> ApiTimetable {
        let xml = SWXMLHash.parse(data)
        let stops: [ApiStop] = try xml["timetable"]["s"].all.map {
            guard let id = $0.element?.attribute(by: "id")?.text,
                let xmlTl = $0["tl"].element,
                let category = xmlTl.attribute(by: "c")?.text,
                let number = xmlTl.attribute(by: "n")?.text else {
                    throw TimetablesDecoderError.decodingError
            }
            let tripLabel = ApiTripLabel(category: category, number: number)
            return ApiStop(id: id,
                           tripLabel: tripLabel,
                           arrival: try _decode(event: $0["ar"].element),
                           departure: try _decode(event: $0["dp"].element))
        }
        return ApiTimetable(stops: stops)
    }

    private func _decode(event: XMLElement?) throws -> ApiEvent? {
        guard let xmlEvent = event else {
            return nil
        }
        guard let platform = xmlEvent.attribute(by: "pp")?.text,
            let time = xmlEvent.attribute(by: "pt")?.text,
            let path = xmlEvent.attribute(by: "ppth")?.text else {
                throw TimetablesDecoderError.decodingError
        }
        return ApiEvent(platform: platform, time: time, path: path)
    }

    // MARK: - Changes decoder

    func decodeChanges(_ data: Data) throws -> ApiChanges {
        let xml = SWXMLHash.parse(data)
        let stops: [ApiChangedStop] = try xml["timetable"]["s"].all.map {
            guard let id = $0.element?.attribute(by: "id")?.text else {
                throw TimetablesDecoderError.decodingError
            }
            return ApiChangedStop(id: id,
                                  arrival: _decode(changedEvent: $0["ar"].element),
                                  departure: _decode(changedEvent: $0["dp"].element))
        }
        return ApiChanges(stops: stops)
    }

    private func _decode(changedEvent: XMLElement?) -> ApiChangedEvent? {
        guard let xmlEvent = changedEvent else { return nil }
        return ApiChangedEvent(platform: xmlEvent.attribute(by: "cp")?.text,
                               time: xmlEvent.attribute(by: "ct")?.text,
                               path: xmlEvent.attribute(by: "cpth")?.text,
                               status: xmlEvent.attribute(by: "cs")?.text)
    }

    // MARK: - Station info decoder

    func decodeStationInfo(_ data: Data) -> [ApiStationInfo] {
        let xml = SWXMLHash.parse(data)
        return xml["stations"]["station"].all.map {
            return ApiStationInfo(meta: $0.element?.attribute(by: "meta")?.text)
        }
    }
}
