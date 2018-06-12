//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct MainScreenViewState: Equatable {
    enum Departure: Equatable {
        case placeholder(String)
        case chosen(String)
    }
    var departure: Departure
}

