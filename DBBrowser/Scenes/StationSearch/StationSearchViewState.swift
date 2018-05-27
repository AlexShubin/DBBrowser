//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxDataSources

enum StationSearchViewState: Equatable {
    
    struct Section: SectionModelType, Equatable {
        var items: [StationCell.State]
        init(original: Section, items: [StationCell.State]) {
            self = original
            self.items = items
        }
        init (items: [StationCell.State]) {
            self.items = items
        }
    }
    
    case stations([Section])
    case loading
    case error
}

extension StationSearchViewState {
    var sections: [Section] {
        if case .stations(let sections) = self {
            return sections
        }
        return []
    }
}

