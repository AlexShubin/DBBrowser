//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class TimetableEventCell: UITableViewCell {
    enum Constants {
        enum CategoryLabel {
            static let topOffset: CGFloat = 8
            static let leadingOffset: CGFloat = 16
            static let bottomOffset: CGFloat = -8
        }
        enum NumberLabel {
            static let leadingOffset: CGFloat = 8
        }
        enum TimeLabel {
            static let trailingOffset: CGFloat = -16
        }
        enum PlatformCaption {
            static let topOffset: CGFloat = 8
            static let leadingOffset: CGFloat = 16
            static let bottomOffset: CGFloat = -8
        }
        enum PlatformLabel {
            static let leadingOffset: CGFloat = 8
        }
        enum BackgroundView {
            static let topOffset: CGFloat = 8
            static let bottomOffset: CGFloat = -8
        }
    }

    private let _backgroundView = UIView()
    private let _categoryLabel = UILabel()
    private let _numberLabel = UILabel()
    private let _timeLabel = UILabel()
    private let _platformCaption = UILabel()
    private let _platformLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupLayout()

        backgroundColor = .clear
        _backgroundView.backgroundColor = .white
        _backgroundView.layer.cornerRadius = 8

        _platformCaption.text = L10n.Timetable.platformCaption
    }

    private func _setupLayout() {
        let headerContainer = UIView()
        headerContainer.addBottomSeparator()
        headerContainer.addSubview(_categoryLabel)
        _categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _categoryLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor,
                                                constant: Constants.CategoryLabel.topOffset),
            _categoryLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor,
                                                    constant: Constants.CategoryLabel.leadingOffset),
            _categoryLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor,
                                                   constant: Constants.CategoryLabel.bottomOffset)
            ])
        headerContainer.addSubview(_numberLabel)
        _numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _numberLabel.leadingAnchor.constraint(equalTo: _categoryLabel.trailingAnchor,
                                                  constant: Constants.NumberLabel.leadingOffset),
            _numberLabel.bottomAnchor.constraint(equalTo: _categoryLabel.bottomAnchor)
            ])
        headerContainer.addSubview(_timeLabel)
        _timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _timeLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor,
                                                 constant: Constants.TimeLabel.trailingOffset),
            _timeLabel.bottomAnchor.constraint(equalTo: _categoryLabel.bottomAnchor)
            ])
        let infoContainer = UIView()
        infoContainer.addSubview(_platformCaption)
        _platformCaption.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _platformCaption.topAnchor.constraint(equalTo: infoContainer.topAnchor,
                                                  constant: Constants.PlatformCaption.topOffset),
            _platformCaption.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor,
                                                      constant: Constants.PlatformCaption.leadingOffset),
            _platformCaption.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor,
                                                     constant: Constants.PlatformCaption.bottomOffset)
            ])
        let stack = UIStackView(arrangedSubviews: [headerContainer, infoContainer])
        stack.axis = .vertical
        _backgroundView.addSubview(stack)
        stack.pinToSuperview()
        contentView.addSubview(_backgroundView)
        _backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: Constants.BackgroundView.topOffset),
            _backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            _backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: Constants.BackgroundView.bottomOffset),
            _backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimetableEventCell: DataDriven {
    struct State: Equatable {
        let category: String
        let number: String
        let time: String
    }

    func render(state: State) {
        _categoryLabel.text = state.category
        _numberLabel.text = state.number
        _timeLabel.text = state.time
    }
}
