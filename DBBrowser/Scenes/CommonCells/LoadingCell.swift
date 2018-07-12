//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    private let _spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupViewHierarchy()

        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupViewHierarchy() {
        addSubview(_spinner)
        _spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _spinner.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            _spinner.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            _spinner.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        _spinner.startAnimating()
    }
}
