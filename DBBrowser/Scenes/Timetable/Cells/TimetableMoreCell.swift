//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TimetableMoreCell: UITableViewCell, Emitable {

    enum Event {
        case moreTap
    }

    private let _button = UIButton(type: .system)
    private let _spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    let events: ControlEvent<Event>

    private(set) var bag = DisposeBag()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        events = ControlEvent(events: _button.rx.tap.map { .moreTap })
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupLayout()

        backgroundColor = .clear
        selectionStyle = .none

        _button.backgroundColor = UIColor(asset: Asset.Colors.dbRed)
        _button.layer.cornerRadius = Constants.Button.cornerRadius
        _button.setTitle(L10n.Timetable.loadMore, for: .normal)
        _button.setTitle("", for: .disabled)
        _button.tintColor = .white
        _button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupLayout() {
        contentView.addSubview(_button)
        _button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _button.topAnchor.constraint(equalTo: contentView.topAnchor,
                                         constant: Constants.Button.topOffset),
            _button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                             constant: Constants.Button.leadingOffset),
            _button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: Constants.Button.trailingOffset),
            _button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                            constant: Constants.Button.bottomOffset),
            _button.heightAnchor.constraint(equalToConstant: Constants.Button.height)
            ])
        contentView.addSubview(_spinner)
        _spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _spinner.centerXAnchor.constraint(equalTo: _button.centerXAnchor),
            _spinner.centerYAnchor.constraint(equalTo: _button.centerYAnchor)
            ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}

// MARK: - DataDriven
extension TimetableMoreCell: DataDriven {
    struct State: Hashable {
        var isLoading: Bool
    }

    func render(state: State) {
        if state.isLoading {
            _spinner.startAnimating()
            _button.isEnabled = false
            _button.setImage(nil, for: .normal)
        } else {
            _spinner.stopAnimating()
            _button.isEnabled = true
            _button.setImage(UIImage(asset: Asset.doubleArrowDown), for: .normal)
        }
    }
}

// MARK: - Constants
private extension TimetableMoreCell {
    enum Constants {
        enum Button {
            static let cornerRadius: CGFloat = 8
            static let leadingOffset: CGFloat = 24
            static let trailingOffset: CGFloat = -24
            static let topOffset: CGFloat = 16
            static let bottomOffset: CGFloat = -8
            static let height: CGFloat = 48
        }
    }
}
