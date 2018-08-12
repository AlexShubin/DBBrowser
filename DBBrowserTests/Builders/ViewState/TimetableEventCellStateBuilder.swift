//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class TimetableEventCellStateBuilder {
    func build() -> TimetableEventCell.State {
        return TimetableEventCell.State(categoryAndNumber: .init(topText: "", bottomText: ""),
                                        timeAndDate: .init(topText: "", bottomText: ""),
                                        platform: .init(topText: "", bottomText: ""),
                                        corrStation: .init(caption: "", station: ""),
                                        throughStation: nil)
    }
}
