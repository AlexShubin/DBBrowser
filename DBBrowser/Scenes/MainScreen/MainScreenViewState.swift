//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct MainScreenViewState: Equatable {
    enum Field: Equatable {
        case placeholder(String)
        case chosen(String)
    }
    var station: Field
    var date: String
    var corrStation: Field
}
