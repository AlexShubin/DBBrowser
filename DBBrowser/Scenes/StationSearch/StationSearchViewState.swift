//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxDataSources

struct StationSearchViewState: Equatable {
    
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
        case station(StationCell.State)
        case loading
        case error
    }
    
    var sections: [Section]
}

