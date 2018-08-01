//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class TimetableEventCell: UITableViewCell {
    private let _backgroundView = UIView()
    private let _headerContainer = UIView()
    private let _infoContainer = UIView()

    private let _categoryLabel = UILabel()
    private let _numberLabel = UILabel()
    private let _timeLabel = UILabel()
    private let _dateLabel = UILabel()
    private let _platformCaption = UILabel()
    private let _platformLabel = UILabel()
    private let _corrStationCaption = UILabel()
    private let _corrStationLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupLayout()

        selectionStyle = .none
        backgroundColor = .clear
        _backgroundView.backgroundColor = .white
        _backgroundView.layer.cornerRadius = Constants.cornerRadius

        _categoryLabel.font = Constants.Fonts.header
        _categoryLabel.textColor = UIColor(asset: Asset.Colors.dbRed)
        _numberLabel.font = Constants.Fonts.smallBold
        _numberLabel.textColor = .black
        _platformCaption.font = Constants.Fonts.smallBold
        _platformCaption.textColor = .gray
        _platformLabel.font = Constants.Fonts.header
        _platformLabel.textColor = UIColor(asset: Asset.Colors.dbRed)
        _timeLabel.font = Constants.Fonts.header
        _timeLabel.textColor = UIColor(asset: Asset.Colors.dbRed)
        _dateLabel.font = Constants.Fonts.smallBold
        _dateLabel.textColor = .gray
        _corrStationCaption.font = Constants.Fonts.smallBold
        _corrStationCaption.textColor = .gray
        _corrStationLabel.font = Constants.Fonts.medium
        _corrStationLabel.textColor = .black

        _platformCaption.text = L10n.Timetable.platformCaption
    }

    private func _setupLayout() {
        _setupHeaderContainerLayout()
        _headerContainer.addBottomSeparator()
        _setupInfoContainerLayout()

        let stack = UIStackView(arrangedSubviews: [_headerContainer, _infoContainer])
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

    private func _setupHeaderContainerLayout() {
        _headerContainer.addSubview(_categoryLabel)
        _categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _categoryLabel.topAnchor.constraint(equalTo: _headerContainer.topAnchor,
                                                constant: Constants.CategoryLabel.topOffset),
            _categoryLabel.leadingAnchor.constraint(equalTo: _headerContainer.leadingAnchor,
                                                    constant: Constants.CategoryLabel.leadingOffset)
            ])
        _headerContainer.addSubview(_numberLabel)
        _numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _numberLabel.leadingAnchor.constraint(equalTo: _headerContainer.leadingAnchor,
                                                  constant: Constants.NumberLabel.leadingOffset),
            _numberLabel.bottomAnchor.constraint(equalTo: _headerContainer.bottomAnchor,
                                                 constant: Constants.NumberLabel.bottomOffset),
            _numberLabel.topAnchor.constraint(equalTo: _categoryLabel.bottomAnchor,
                                              constant: Constants.NumberLabel.topOffset)
            ])
        _headerContainer.addSubview(_platformCaption)
        _platformCaption.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _platformCaption.centerYAnchor.constraint(equalTo: _numberLabel.centerYAnchor),
            _platformCaption.centerXAnchor.constraint(equalTo: _headerContainer.centerXAnchor,
                                                      constant: Constants.PlatformCaption.leadingOffset)
            ])
        _headerContainer.addSubview(_platformLabel)
        _platformLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _platformLabel.centerYAnchor.constraint(equalTo: _categoryLabel.centerYAnchor),
            _platformLabel.centerXAnchor.constraint(equalTo: _headerContainer.centerXAnchor,
                                                    constant: Constants.PlatformLabel.leadingOffset)
            ])
        _headerContainer.addSubview(_timeLabel)
        _timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _timeLabel.trailingAnchor.constraint(equalTo: _headerContainer.trailingAnchor,
                                                 constant: Constants.TimeLabel.trailingOffset),
            _timeLabel.centerYAnchor.constraint(equalTo: _categoryLabel.centerYAnchor)
            ])
        _headerContainer.addSubview(_dateLabel)
        _dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _dateLabel.trailingAnchor.constraint(equalTo: _headerContainer.trailingAnchor,
                                                 constant: Constants.DateLabel.trailingOffset),
            _dateLabel.centerYAnchor.constraint(equalTo: _numberLabel.centerYAnchor)
            ])
    }

    private func _setupInfoContainerLayout() {
        _infoContainer.addSubview(_corrStationCaption)
        _corrStationCaption.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _corrStationCaption.leadingAnchor.constraint(equalTo: _infoContainer.leadingAnchor,
                                                         constant: Constants.CorrStationCaption.leadingOffset)
            ])
        _infoContainer.addSubview(_corrStationLabel)
        _corrStationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _corrStationLabel.leadingAnchor.constraint(equalTo: _corrStationCaption.trailingAnchor,
                                                       constant: Constants.CorrStation.leadingOffset),
            _corrStationLabel.bottomAnchor.constraint(equalTo: _infoContainer.bottomAnchor,
                                                      constant: Constants.CorrStation.bottomOffset),
            _corrStationLabel.topAnchor.constraint(equalTo: _infoContainer.topAnchor,
                                                   constant: Constants.CorrStation.topOffset),
            _corrStationLabel.centerYAnchor.constraint(equalTo: _corrStationCaption.centerYAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataDriven
extension TimetableEventCell: DataDriven {
    struct State: Hashable {
        let category: String
        let number: String
        let time: String
        let platform: String
        let date: String
        let corrStationCaption: String
        let corrStation: String
    }

    func render(state: State) {
        _categoryLabel.text = state.category
        _numberLabel.text = state.number
        _timeLabel.text = state.time
        _platformLabel.text = state.platform
        _dateLabel.text = state.date
        _corrStationCaption.text = state.corrStationCaption
        _corrStationLabel.text = state.corrStation
    }
}

// MARK: - Constants
extension TimetableEventCell {
    enum Constants {
        enum CategoryLabel {
            static let topOffset: CGFloat = 8
            static let leadingOffset: CGFloat = 16
        }
        enum NumberLabel {
            static let leadingOffset: CGFloat = 16
            static let topOffset: CGFloat = 4
            static let bottomOffset: CGFloat = -8
        }
        enum TimeLabel {
            static let trailingOffset: CGFloat = -16
        }
        enum DateLabel {
            static let trailingOffset: CGFloat = -16
        }
        enum PlatformCaption {
            static let leadingOffset: CGFloat = -10
        }
        enum PlatformLabel {
            static let leadingOffset: CGFloat = -10
        }
        enum BackgroundView {
            static let topOffset: CGFloat = 8
            static let bottomOffset: CGFloat = -8
        }
        enum CorrStationCaption {
            static let leadingOffset: CGFloat = 16
        }
        enum CorrStation {
            static let leadingOffset: CGFloat = 8
            static let topOffset: CGFloat = 8
            static let bottomOffset: CGFloat = -8
        }
        enum Fonts {
            static let header = UIFont.boldSystemFont(ofSize: 20)
            static let smallBold = UIFont.boldSystemFont(ofSize: 14)
            static let medium = UIFont.systemFont(ofSize: 16)
        }
        static let cornerRadius: CGFloat = 8
    }
}
