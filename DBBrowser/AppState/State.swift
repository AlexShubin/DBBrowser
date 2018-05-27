//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

protocol State {
    associatedtype Event
    static var initial: Self { get }
    static func reduce(state: Self, event: Event) -> Self
}
