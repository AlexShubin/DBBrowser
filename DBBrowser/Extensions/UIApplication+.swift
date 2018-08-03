//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

extension UIApplication {
    public static var isInUnitTesting: Bool {
        return isTesting && !isInUITesting
    }

    private static var isTesting: Bool {
        return NSClassFromString("XCTest") != nil
    }

    private static var isInUITesting: Bool {
        return ProcessInfo.processInfo.environment["isUITest"] != nil
    }
}
