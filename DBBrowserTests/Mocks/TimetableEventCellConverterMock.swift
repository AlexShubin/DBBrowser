//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation

final class TimetableEventCellConverterMock: TimetableEventCellConverterType {
    func convert(from event: Timetable.Event,
                 table: TimetableState.Table,
                 userCorrStation: Station?) -> TimetableEventCell.State {
        invocations.append(.convert(event, table, userCorrStation))
        return expected
    }

    enum Invocation: Equatable {
        case convert(Timetable.Event, TimetableState.Table, Station?)
    }

    var invocations = [Invocation]()
    var expected = TimetableEventCellStateBuilder().build()
}
