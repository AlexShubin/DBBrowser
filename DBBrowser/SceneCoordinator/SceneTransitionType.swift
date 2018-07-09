//
//  Created by Alex Shubin on 20/10/2017.
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import Foundation

enum SceneTransitionType {
    // you can extend this to add animated transition types,
    // interactive transitions and even child view controllers!

    case root       // make view controller the root view controller
    case push       // push view controller to navigation stack
    case modal      // present view controller modally
}
