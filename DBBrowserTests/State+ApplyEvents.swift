//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

extension State {
    static func applyEvents(initial: Self, events: [Event]) -> Self {
        return events.reduce(initial) { (result, event) -> Self in
            Self.reduce(state: result, event: event)
        }
    }
}
