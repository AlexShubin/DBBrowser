//
// Copyright © 2018 LLC "Globus Media". All rights reserved.
//

import UIKit

protocol StateStoreBindable {
    /// General system state.
    associatedtype StateStore
    /// State subscribtion.
    func subscribe(to stateStore: StateStore)
}

extension StateStoreBindable where Self: UIViewController {
    mutating func bind(with stateStore: Self.StateStore) {
        loadViewIfNeeded()
        subscribe(to: stateStore)
    }
}
