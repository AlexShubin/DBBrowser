//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol DataDriven {
    associatedtype State
    func render(state: State)
}

public protocol DataDrivenAnimatable: DataDriven {
    func render(state: State, animate: Bool)
}

public protocol Emitable {
    associatedtype Event
    var events: ControlEvent<Event> { get }
}
