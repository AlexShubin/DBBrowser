//
//  DatePickerViewController.swift
//  DBBrowser
//
//  Created by Alex Shubin on 13/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DatePickerViewController: UIViewController {

    let bag = DisposeBag()

    //private let _converter: StationSearchViewStateConverter

    private let _topContainerView = RoundedView()
    private let _bottomContainerView = UIView()
    private let _topLabel = UILabel()
    private let _datePicker = UIDatePicker()

//    init(converter: StationSearchViewStateConverter) {
//        _converter = converter
//        super.init(nibName: nil, bundle: nil)
//    }

        init() {
            super.init(nibName: nil, bundle: nil)
        }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupLayout()

        view.backgroundColor = .clear

        _topContainerView.backgroundColor = .white
        _topContainerView.roundedCorners = [.topLeft, .topRight]
        _topContainerView.cornerRadius = 16
        _topContainerView.addBottomSeparator()

        _topLabel.text = L10n.DatePicker.topLabel
        _topLabel.font = UIFont.DB.headerSmall

        _bottomContainerView.backgroundColor = .white
    }

    private func _setupLayout() {
        view.addSubview(_topContainerView)
        _topContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        _topContainerView.addSubview(_topLabel)
        _topLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _topLabel.leadingAnchor.constraint(equalTo: _topContainerView.leadingAnchor,
                                               constant: Constants.TopLabel.leadingOffset),
            _topLabel.topAnchor.constraint(equalTo: _topContainerView.topAnchor,
                                           constant: Constants.TopLabel.topOffset),
            _topLabel.bottomAnchor.constraint(equalTo: _topContainerView.bottomAnchor,
                                              constant: Constants.TopLabel.bottomOffset)
            ])
        view.addSubview(_bottomContainerView)
        _bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _bottomContainerView.topAnchor.constraint(equalTo: _topContainerView.bottomAnchor),
            _bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            _bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        _bottomContainerView.addSubview(_datePicker)
        _datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _datePicker.topAnchor.constraint(equalTo: _bottomContainerView.topAnchor,
                                             constant: Constants.DatePicker.topOffset),
            _datePicker.bottomAnchor.constraint(equalTo: _bottomContainerView.bottomAnchor,
                                                constant: Constants.DatePicker.bottomOffset),
            _datePicker.leadingAnchor.constraint(equalTo: _bottomContainerView.leadingAnchor),
            _datePicker.trailingAnchor.constraint(equalTo: _bottomContainerView.trailingAnchor)
            ])
    }
}

// MARK: - Constants
private extension DatePickerViewController {
    enum Constants {
        enum TopLabel {
            static let topOffset: CGFloat = 16
            static let leadingOffset: CGFloat = 16
            static let bottomOffset: CGFloat = -16
        }
        enum DatePicker {
            static let topOffset: CGFloat = 80
            static let bottomOffset: CGFloat = -80
        }
    }
}
