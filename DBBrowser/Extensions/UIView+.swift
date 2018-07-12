//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

extension UIView {
    func addBottomSeparator() {
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0, alpha: 0.1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }

    func pinToSuperview() {
        guard let sv = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: sv.leadingAnchor),
            trailingAnchor.constraint(equalTo: sv.leadingAnchor),
            topAnchor.constraint(equalTo: sv.topAnchor),
            bottomAnchor.constraint(equalTo: sv.bottomAnchor)
            ])
    }
}
