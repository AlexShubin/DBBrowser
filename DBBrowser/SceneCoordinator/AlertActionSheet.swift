//
//  Copyright © 2017 LLC "Globus Media". All rights reserved.
//

import UIKit

enum AlertActionSheet {
    struct AlertData {
        let title: String
        let message: String?
        let actions: [Action]
    }

    struct Action {
        let title: String
        let style: UIAlertActionStyle
        let handler: ((UIAlertAction) -> Void)?
    }

    case alert(data: AlertData, textField: ((UITextField) -> Void)?)
    case actionSheet(data: AlertData, sender: UIView)
}
