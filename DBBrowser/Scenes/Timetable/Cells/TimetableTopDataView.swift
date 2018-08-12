//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class TimetableTopDataView: UIView {

    private let _topLabel = UILabel()
    private let _bottomLabel = UILabel()

    private let _alignment: NSTextAlignment

    init(alignment: NSTextAlignment) {
        _alignment = alignment
        super.init(frame: .zero)
        _setupLayout()

        _topLabel.font = UIFont.DB.header
        _topLabel.textColor = UIColor(asset: Asset.Colors.dbRed)
        _topLabel.textAlignment = _alignment
        _bottomLabel.font = UIFont.DB.boldCaption
        _bottomLabel.textColor = .gray
        _bottomLabel.textAlignment = _alignment
    }

    private func _setupLayout() {
        addSubview(_topLabel)
        _topLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _topLabel.topAnchor.constraint(equalTo: topAnchor),
            _topLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            _topLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        addSubview(_bottomLabel)
        _bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            _bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            _bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            _bottomLabel.topAnchor.constraint(equalTo: _topLabel.bottomAnchor,
                                              constant: Constants.BottomLabel.topOffset)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataDriven
extension TimetableTopDataView: DataDriven {
    struct State: Hashable {
        let topText: String
        let bottomText: String
    }

    func render(state: State) {
        _topLabel.text = state.topText
        _bottomLabel.text = state.bottomText
    }
}

// MARK: - Constants
extension TimetableTopDataView {
    enum Constants {
        enum BottomLabel {
            static let topOffset: CGFloat = 4
        }
    }
}
