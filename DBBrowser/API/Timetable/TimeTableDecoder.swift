//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import SWXMLHash

protocol TimeTableDecoder {
    func decode(_ data: Data) -> [TimetableStop]?
}

struct XMLTimeTableDecoder {
    func decode(_ data: Data) -> [TimetableStop]? {
        let xml = SWXMLHash.parse(data)
        return xml["timetable"]["s"].all.compactMap {
            let xmlTl = $0["tl"].element
            let tl = TimetableStop.TripLabel(o: xmlTl?.attribute(by: "o")?.text,
                                             c: xmlTl?.attribute(by: "c")?.text,
                                             n: xmlTl?.attribute(by: "n")?.text)
            return TimetableStop(tl: tl,
                                 ar: _decode($0["ar"].element),
                                 dp: _decode($0["dp"].element))
        }
    }
    
    private func _decode(_ event: XMLElement?) -> TimetableStop.Event? {
        guard let xmlEvent = event else {
            return nil
        }
        return TimetableStop.Event(pp: xmlEvent.attribute(by: "pp")?.text,
                                   pt: xmlEvent.attribute(by: "pt")?.text,
                                   ppth: xmlEvent.attribute(by: "ppth")?.text)
    }
}
