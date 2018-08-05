//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputField: UIView, Emitable {

    private let _caption = UILabel()
    private let _label = UILabel()

    enum Event {
        case tap
    }
    let events: ControlEvent<Event>

    init() {
        let labelTapRecognizer = UITapGestureRecognizer()
        events = ControlEvent(events: labelTapRecognizer.rx.event.map { _ in .tap })
        super.init(frame: .zero)

        let horStack = UIStackView(arrangedSubviews: [_label])
        horStack.axis = .horizontal

        let vertStack = UIStackView(arrangedSubviews: [_caption, horStack])
        vertStack.axis = .vertical
        vertStack.spacing = Constants.Field.spacing

        _caption.font = Constants.Fonts.caption
        _label.font = Constants.Fonts.label
        _label.isUserInteractionEnabled = true
        _label.addGestureRecognizer(labelTapRecognizer)

        addSubview(vertStack)
        vertStack.pinToSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
}

// MARK: - Constants

private extension InputField {
    enum Constants {
        enum Fonts {
            static let caption = UIFont.systemFont(ofSize: 16)
            static let label = UIFont.systemFont(ofSize: 34, weight: .medium)
        }
        enum Field {
            static let spacing: CGFloat = 4
        }
    }
}
