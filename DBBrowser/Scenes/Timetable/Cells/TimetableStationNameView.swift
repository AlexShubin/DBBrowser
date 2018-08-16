//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class TimetableStationNameView: UIView {

    private let _caption = UILabel()
    private let _stationLabel = UILabel()

    init() {
        super.init(frame: .zero)
        _setupLayout()

        _caption.font = UIFont.DB.boldCaptionSmall
        _caption.textColor = .gray
        _stationLabel.font = UIFont.DB.regular
        _stationLabel.textColor = .black
    }

    private func _setupLayout() {
        addSubview(_caption)
        _caption.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _caption.topAnchor.constraint(equalTo: topAnchor),
            _caption.leadingAnchor.constraint(equalTo: leadingAnchor),
            _caption.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        _caption.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(_stationLabel)
        _stationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _stationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            _stationLabel.leadingAnchor.constraint(equalTo: _caption.trailingAnchor,
                                                  constant: Constants.StationLabel.leadingOffset),
            _stationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            _stationLabel.topAnchor.constraint(equalTo: topAnchor)
            ])
        _stationLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataDriven
extension TimetableStationNameView: DataDriven {
    struct State: Hashable {
        let caption: String
        let station: String
    }

    func render(state: State) {
        _caption.text = state.caption
        _stationLabel.text = state.station
    }
}

// MARK: - Constants
extension TimetableStationNameView {
    enum Constants {
        enum StationLabel {
            static let leadingOffset: CGFloat = 8
        }
    }
}
