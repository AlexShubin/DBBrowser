//
//  Created by Alex Shubin on 20/10/2017.
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import UIKit

enum Scene {
    
    case mainScreen
    
    var viewController: UIViewController {
        //let appStateStore = (UIApplication.shared.delegate as! AppDelegate).appStateStore!
        switch self {
        case .mainScreen:
            let vc = UIViewController()
            //vc.bind(with: appStateStore)
            return vc
        }
    }
}
