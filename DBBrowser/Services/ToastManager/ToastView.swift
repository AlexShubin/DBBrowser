//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class ToastView: UIView {
    private let _label = UILabel()

    init() {
        super.init(frame: .zero)
        addSubview(_label)
        _label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _label.centerXAnchor.constraint(equalTo: centerXAnchor),
            _label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
            ])
        _label.textColor = .white
        _label.font = UIFont.DB.captionSmall
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToastView: DataDriven {
    struct State {
        var color: UIColor
        var text: String
    }
    func render(state: State) {
        backgroundColor = state.color
        _label.text = state.text
    }
}
