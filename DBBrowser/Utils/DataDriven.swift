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

public protocol StateConverter {
    associatedtype State
    associatedtype DataDrivenState
    func convert(state: State) -> DataDrivenState
}

public protocol Emitable {
    associatedtype Event
    /// События, генерируемые View
    var events: ControlEvent<Event> { get }
}

