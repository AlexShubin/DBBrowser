//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class TimetableEventCell: UITableViewCell {
    private let _backgroundView = UIView()
    private let _headerContainer = UIView()
    private let _infoContainer = UIView()

    private let _categoryAndNumberView = TimetableTopDataView(alignment: .left)
    private let _timeAndDateView = TimetableTopDataView(alignment: .right)
    private let _platformView = TimetableTopDataView(alignment: .center)
    private let _corrStationView = TimetableStationNameView()
    private let _throughStationView = TimetableStationNameView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupLayout()

        selectionStyle = .none
        backgroundColor = .clear
        _backgroundView.backgroundColor = .white
        _backgroundView.layer.cornerRadius = Constants.cornerRadius
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
        _headerContainer.addSubview(_categoryAndNumberView)
        _categoryAndNumberView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _categoryAndNumberView.topAnchor.constraint(equalTo: _headerContainer.topAnchor,
                                                        constant: Constants.CategoryAndNumberView.topOffset),
            _categoryAndNumberView.leadingAnchor.constraint(equalTo: _headerContainer.leadingAnchor,
                                                            constant: Constants.CategoryAndNumberView.leadingOffset),
            _categoryAndNumberView.bottomAnchor.constraint(equalTo: _headerContainer.bottomAnchor,
                                                           constant: Constants.CategoryAndNumberView.bottomOffset)
            ])
        _headerContainer.addSubview(_platformView)
        _platformView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _platformView.centerYAnchor.constraint(equalTo: _categoryAndNumberView.centerYAnchor),
            _platformView.centerXAnchor.constraint(equalTo: _headerContainer.centerXAnchor,
                                                   constant: Constants.PlatformView.xOffset)
            ])
        _headerContainer.addSubview(_timeAndDateView)
        _timeAndDateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _timeAndDateView.trailingAnchor.constraint(equalTo: _headerContainer.trailingAnchor,
                                                       constant: Constants.TimeAndDateView.trailingOffset),
            _timeAndDateView.centerYAnchor.constraint(equalTo: _categoryAndNumberView.centerYAnchor)
            ])
    }

    private func _setupInfoContainerLayout() {
        let stationStack = UIStackView(arrangedSubviews: [_corrStationView, _throughStationView])
        stationStack.axis = .vertical
        stationStack.spacing = Constants.StationStack.spacing
        _infoContainer.addSubview(stationStack)
        stationStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stationStack.leadingAnchor.constraint(equalTo: _infoContainer.leadingAnchor,
                                                  constant: Constants.StationStack.leadingOffset),
            stationStack.bottomAnchor.constraint(equalTo: _infoContainer.bottomAnchor,
                                                 constant: Constants.StationStack.bottomOffset),
            stationStack.topAnchor.constraint(equalTo: _infoContainer.topAnchor,
                                              constant: Constants.StationStack.topOffset),
            stationStack.trailingAnchor.constraint(equalTo: _infoContainer.trailingAnchor,
                                                   constant: Constants.StationStack.trailingOffset)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataDriven
extension TimetableEventCell: DataDriven {
    struct State: Equatable {
        let categoryAndNumber: TimetableTopDataView.State
        let timeAndDate: TimetableTopDataView.State
        let platform: TimetableTopDataView.State
        let corrStation: TimetableStationNameView.State
        let throughStation: TimetableStationNameView.State?
    }

    func render(state: State) {
        _categoryAndNumberView.render(state: state.categoryAndNumber)
        _timeAndDateView.render(state: state.timeAndDate)
        _platformView.render(state: state.platform)
        _corrStationView.render(state: state.corrStation)
        if let throughStation = state.throughStation {
            _throughStationView.render(state: throughStation)
            _throughStationView.isHidden = false
        } else {
            _throughStationView.isHidden = true
        }
    }
}

// MARK: - Constants
extension TimetableEventCell {
    enum Constants {
        enum CategoryAndNumberView {
            static let topOffset: CGFloat = 8
            static let leadingOffset: CGFloat = 16
            static let bottomOffset: CGFloat = -8
        }
        enum TimeAndDateView {
            static let trailingOffset: CGFloat = -16
        }
        enum PlatformView {
            static let xOffset: CGFloat = -10
        }
        enum BackgroundView {
            static let topOffset: CGFloat = 8
            static let bottomOffset: CGFloat = -8
        }
        enum StationStack {
            static let leadingOffset: CGFloat = 16
            static let topOffset: CGFloat = 8
            static let bottomOffset: CGFloat = -10
            static let trailingOffset: CGFloat = -16
            static let spacing: CGFloat = 4
        }
        static let cornerRadius: CGFloat = 8
    }
}
