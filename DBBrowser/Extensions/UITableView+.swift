//
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import UIKit

extension UITableView {

    func registerCell<T: UITableViewCell>(ofType type: T.Type) {
        let typeName = String(describing: type)
        register(type, forCellReuseIdentifier: typeName)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let typeName = String(describing: T.self)
        //swiftlint:disable force_cast
        return dequeueReusableCell(withIdentifier: typeName, for: indexPath) as! T
        //swiftlint:enable force_cast
    }
}
