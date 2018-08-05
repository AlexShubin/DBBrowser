//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputField: UIView, Emitable {

    private let _caption = UILabel()
    private let _label = UILabel()
    private let _clearButton = UIButton(type: .system)

    enum Event {
        case tap
        case clear
    }
    let events: ControlEvent<Event>

    init() {
        let labelTapRecognizer = UITapGestureRecognizer()
        events = ControlEvent(events:
            Observable.merge(labelTapRecognizer.rx.event.map { _ in .tap },
                             _clearButton.rx.tap.map { .clear }
            )
        )
        super.init(frame: .zero)
        setupLayout()

        _clearButton.setImage(UIImage(asset: Asset.btnClose), for: .normal)
        _clearButton.tintColor = UIColor(asset: Asset.Colors.dbRed)

        _caption.font = Constants.Fonts.caption

        _label.font = Constants.Fonts.label
        _label.isUserInteractionEnabled = true
        _label.addGestureRecognizer(labelTapRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let horStack = UIStackView(arrangedSubviews: [_label, _clearButton])
        horStack.axis = .horizontal

        let vertStack = UIStackView(arrangedSubviews: [_caption, horStack])
        vertStack.axis = .vertical
        vertStack.spacing = Constants.Field.spacing

        addSubview(vertStack)
        vertStack.pinToSuperview()
        _clearButton.widthAnchor.constraint(equalToConstant: Constants.ClearButton.width).isActive = true
    }
}

// MARK: - DataDriven

extension InputField: DataDriven {
    struct State: Equatable {
        enum Field: Equatable {
            case placeholder(String)
            case chosen(String)
        }
        var field: Field
        var caption: String
        var isClearButtonHidden: Bool
    }
    func render(state: State) {
        _caption.text = state.caption
        switch state.field {
        case .placeholder(let str):
            _label.text = str
            _label.textColor = .lightGray
        case .chosen(let str):
            _label.text = str
            _label.textColor = .black
        }
        _clearButton.isHidden = state.isClearButtonHidden
    }
}

// MARK: - Constants

private extension InputField {
    enum Constants {
        enum Fonts {
            static let caption = UIFont.systemFont(ofSize: 16)
            static let label = UIFont.systemFont(ofSize: 32, weight: .medium)
        }
        enum Field {
            static let spacing: CGFloat = 4
        }
        enum ClearButton {
            static let width: CGFloat = 36
        }
    }
}
