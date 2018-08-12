//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

protocol TimetableEventCellConverterType {
    func convert(from event: Timetable.Event,
                 table: TimetableState.Table,
                 userCorrStation: Station?) -> TimetableEventCell.State
}

struct TimetableEventCellConverter: TimetableEventCellConverterType {

    private let _dateFormatter: DateTimeFormatter

    init(dateFormatter: DateTimeFormatter) {
        _dateFormatter = dateFormatter
    }

    func convert(from event: Timetable.Event,
                 table: TimetableState.Table,
                 userCorrStation: Station?) -> TimetableEventCell.State {
        let corrStationCaption: String
        let corrStation: String
        switch table {
        case .departures:
            corrStationCaption = L10n.Timetable.towards
            corrStation = event.stations.last!
        case .arrivals:
            corrStationCaption = L10n.Timetable.from
            corrStation = event.stations.first!
        }
        let throughStation: TimetableStationNameView.State?
        if let _userCorrStation = userCorrStation,
            !_userCorrStation.name.interrelated(to: corrStation) {
            throughStation = TimetableStationNameView.State(caption: L10n.Timetable.through,
                                                            station: _userCorrStation.name)
        } else {
            throughStation = nil
        }
        return TimetableEventCell.State(
            categoryAndNumber: .init(topText: event.category,
                                     bottomText: event.number),
            timeAndDate: .init(topText: _dateFormatter.string(from: event.time,
                                                              style: .userTimetableTime),
                               bottomText: _dateFormatter.string(from: event.time,
                                                                 style: .userTimetableDate)),
            platform: .init(topText: event.platform,
                            bottomText: L10n.Timetable.platformCaption),
            corrStation: .init(caption: corrStationCaption,
                               station: corrStation),
            throughStation: throughStation
        )
    }
}
