//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct MainScreenViewState: Equatable {
    enum Station: Equatable {
        case placeholder(String)
        case chosen(String)
    }
    var station: Station
}
