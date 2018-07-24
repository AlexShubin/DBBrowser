//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxDataSources

struct TimetableViewState: Equatable {

    struct Section: AnimatableSectionModelType, Hashable {
        var items: [SectionItem]
        init(original: Section, items: [SectionItem]) {
            self = original
            self.items = items
        }
        init (items: [SectionItem]) {
            self.items = items
        }
        var hashValue: Int {
            return items.reduce(0) {
                $0 ^ $1.hashValue
            }
        }
        var identity: Section {
            return self
        }
    }

    enum SectionItem: IdentifiableType, Hashable {
        case event(TimetableEventCell.State)
        case loading
        case error
        var identity: SectionItem {
            return self
        }
    }

    var sections: [Section]
    var segmentedControlIndex: Int
}
