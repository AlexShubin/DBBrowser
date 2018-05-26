//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxDataSources

struct StationSearchViewState {
    
    struct Section: SectionModelType {
        typealias Item = SectionItem
        var items: [Item]
        init(original: Section, items: [Item]) {
            self = original
            self.items = items
        }
        init (items: [Item]) {
            self.items = items
        }
    }
    
    enum SectionItem: Equatable {
        case station
        case loading
        case error
    }
    
    var sections: [Section]
}

