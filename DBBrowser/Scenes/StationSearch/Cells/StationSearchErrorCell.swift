//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StationSearchErrorCell: UITableViewCell, Emitable {
    
    enum Event {
        case retryTap
    }
    
    private let _errorImage = UIImageView(image: UIImage(asset: Asset.error))
    private let _label = UILabel()
    private let _retryButton = UIButton(type: .system)
    
    var bag = DisposeBag()
    let events: ControlEvent<Event>
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        events = ControlEvent(events: _retryButton.rx.tap.map { .retryTap })
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupLayout()
        
        backgroundColor = .clear
        _errorImage.tintColor = .lightGray
        _retryButton.setTitle(L10n.retryButtonText, for: .normal)
        _label.text = L10n.loadingError
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupLayout() {
        addSubview(_errorImage)
        _errorImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _errorImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            _errorImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            _errorImage.widthAnchor.constraint(equalToConstant: 80),
            _errorImage.heightAnchor.constraint(equalToConstant: 80)
            ])
        addSubview(_label)
        _label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _label.topAnchor.constraint(equalTo: _errorImage.bottomAnchor, constant: 12),
            _label.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
        addSubview(_retryButton)
        _retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _retryButton.topAnchor.constraint(equalTo: _label.bottomAnchor, constant: 8),
            _retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            _retryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
