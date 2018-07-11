//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class TimetableEventCell: UITableViewCell {
    struct State {
        let category: String
        let number: String
        let time: String
    }
    
    enum Constants {
        enum CategoryLabel {
            static let topOffset: CGFloat = 8
            static let leadingOffset: CGFloat = 16
            static let bottomOffset: CGFloat = -8
        }
        enum NumberLabel {
            static let leadingOffset: CGFloat = 16
        }
        enum TimeLabel {
            static let trailingOffset: CGFloat = -16
        }
    }
    
    private let _categoryLabel = UILabel()
    private let _numberLabel = UILabel()
    private let _timeLabel = UILabel()
    private let _platformCaption = UILabel()
    private let _platformLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setupLayout()
    }
    
    private func _setupLayout() {
        contentView.addSubview(_categoryLabel)
        _categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: Constants.CategoryLabel.topOffset),
            _categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: Constants.CategoryLabel.leadingOffset),
            _categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: Constants.CategoryLabel.bottomOffset)
            ])
        contentView.addSubview(_numberLabel)
        _numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _numberLabel.leadingAnchor.constraint(equalTo: _categoryLabel.leadingAnchor,
                                                  constant: Constants.NumberLabel.leadingOffset),
            _numberLabel.bottomAnchor.constraint(equalTo: _categoryLabel.bottomAnchor)
            ])
        contentView.addSubview(_timeLabel)
        _timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: Constants.TimeLabel.trailingOffset),
            _timeLabel.bottomAnchor.constraint(equalTo: _categoryLabel.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
