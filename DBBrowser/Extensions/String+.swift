//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

extension String {
    /// Returns true if a string contains the other string or vice versa.
    func interrelated(to other: String) -> Bool {
        return contains(other) || other.contains(self)
    }
}
