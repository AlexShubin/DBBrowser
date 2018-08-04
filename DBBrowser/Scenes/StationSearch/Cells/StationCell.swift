//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {

    struct State: Hashable {
        var stationName: String
    }

    private let _stationNameLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupUI() {
        addSubview(_stationNameLabel)
        _stationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _stationNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            _stationNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            _stationNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            _stationNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ])
        addBottomSeparator()
    }
}

extension StationCell: DataDriven {
    func render(state: State) {
        _stationNameLabel.text = state.stationName
    }
}
