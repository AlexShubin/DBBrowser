//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxDataSources

struct TimetableViewState: Equatable {

    struct Section: SectionModelType, Equatable {
        var items: [SectionItem]
        init(original: Section, items: [SectionItem]) {
            self = original
            self.items = items
        }
        init (items: [SectionItem]) {
            self.items = items
        }
    }

    enum SectionItem: Equatable {
        case event(TimetableEventCell.State)
        case loading
        case error
    }

    var sections: [Section]
    var segmentedControlIndex: Int
}
