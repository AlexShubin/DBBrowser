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

    private let _converter: DatePickerViewStateConverter

    private let _topContainerView = RoundedView()
    private let _bottomContainerView = UIView()
    private let _topLabel = UILabel()
    private let _commentLabel = UILabel()
    private let _doneButton = UIButton(type: .system)
    private let _cancelButton = UIButton(type: .system)
    private let _datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = TimeZone.CEST
        picker.minimumDate = Date()
        picker.maximumDate = picker.minimumDate?.adding(hours: Constants.timetableAvailableForNextHours)
        return picker
    }()

    init(converter: DatePickerViewStateConverter) {
        _converter = converter
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
        _commentLabel.text = L10n.DatePicker.availablility(Constants.timetableAvailableForNextHours)
        _commentLabel.font = UIFont.DB.boldCaptionSmall
        _commentLabel.textColor = .gray

        _bottomContainerView.backgroundColor = UIColor(asset: Asset.Colors.backgroundGray)

        _doneButton.backgroundColor = UIColor(asset: Asset.Colors.dbRed)
        _doneButton.layer.cornerRadius = 8
        _doneButton.setTitle(L10n.DatePicker.doneButtonLabel, for: .normal)
        _doneButton.tintColor = .white

        _cancelButton.setTitle(L10n.cancelButtonText, for: .normal)
        _cancelButton.tintColor = UIColor(asset: Asset.Colors.dbRed)
    }

    private func _setupLayout() {
        _setupTopContainer()
        _setupBottomContainer()
    }

    private func _setupTopContainer() {
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
                                           constant: Constants.TopLabel.topOffset)
            ])
        _topContainerView.addSubview(_commentLabel)
        _commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _commentLabel.leadingAnchor.constraint(equalTo: _topContainerView.leadingAnchor,
                                               constant: Constants.CommentLabel.leadingOffset),
            _commentLabel.topAnchor.constraint(equalTo: _topLabel.bottomAnchor,
                                           constant: Constants.CommentLabel.topOffset),
            _commentLabel.bottomAnchor.constraint(equalTo: _topContainerView.bottomAnchor,
                                              constant: Constants.CommentLabel.bottomOffset),
            _commentLabel.trailingAnchor.constraint(equalTo: _topContainerView.trailingAnchor,
                                                    constant: Constants.CommentLabel.trailingOffset)
            ])
        _topContainerView.addSubview(_cancelButton)
        _cancelButton.translatesAutoresizingMaskIntoConstraints = false
        _cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            _cancelButton.trailingAnchor.constraint(equalTo: _topContainerView.trailingAnchor,
                                                    constant: Constants.CancelButton.trailingOffset),
            _cancelButton.leadingAnchor.constraint(equalTo: _topLabel.trailingAnchor),
            _cancelButton.centerYAnchor.constraint(equalTo: _topLabel.centerYAnchor)
            ])
    }

    private func _setupBottomContainer() {
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
            _datePicker.leadingAnchor.constraint(equalTo: _bottomContainerView.leadingAnchor),
            _datePicker.trailingAnchor.constraint(equalTo: _bottomContainerView.trailingAnchor)
            ])
        _bottomContainerView.addSubview(_doneButton)
        _doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _doneButton.topAnchor.constraint(equalTo: _datePicker.bottomAnchor,
                                             constant: Constants.DoneButton.topOffset),
            _doneButton.leadingAnchor.constraint(equalTo: _bottomContainerView.leadingAnchor,
                                                 constant: Constants.DoneButton.leadingOffset),
            _doneButton.trailingAnchor.constraint(equalTo: _bottomContainerView.trailingAnchor,
                                                  constant: Constants.DoneButton.trailingOffset),
            _doneButton.bottomAnchor.constraint(equalTo: _bottomContainerView.bottomAnchor,
                                                constant: Constants.DoneButton.bottomOffset),
            _doneButton.heightAnchor.constraint(equalToConstant: Constants.DoneButton.height)
            ])
    }
}
// MARK: - DataDriven
extension DatePickerViewController: StateStoreBindable {
    func subscribe(to stateStore: StateStore) {
        // State to view state conversion
        let viewState: Signal<DatePickerViewState> = stateStore
            .stateBus
            .map { $0.timetable }
            .distinctUntilChanged()
            .map { [weak self] in self?._converter.convert(from: $0) }
            .filterNil()
        // State render
        viewState
            .map { $0.date }
            .asObservable()
            .take(1)
            .bind(to: _datePicker.rx.date)
            .disposed(by: bag)
        // UI Events
        _doneButton.rx.tap
            .flatMap { [weak self] () -> Observable<AppEvent> in
                guard let date = self?._datePicker.date else {
                    return .empty()
                }
                return .of(.timetable(.date(date)),
                           .coordinator(.close(.modal)))
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        _cancelButton.rx.tap
            .map { .coordinator(.close(.modal)) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }
}

// MARK: - Constants
private extension DatePickerViewController {
    enum Constants {
        enum TopLabel {
            static let topOffset: CGFloat = 16
            static let leadingOffset: CGFloat = 16
        }
        enum CancelButton {
            static let trailingOffset: CGFloat = -16
        }
        enum CommentLabel {
            static let topOffset: CGFloat = 8
            static let leadingOffset: CGFloat = 16
            static let bottomOffset: CGFloat = -16
            static let trailingOffset: CGFloat = -16
        }
        enum DatePicker {
            static let topOffset: CGFloat = 24
        }
        enum DoneButton {
            static let topOffset: CGFloat = 24
            static let bottomOffset: CGFloat = -48
            static let leadingOffset: CGFloat = 24
            static let trailingOffset: CGFloat = -24
            static let height: CGFloat = 48
        }
        static let timetableAvailableForNextHours = 18
    }
}

// MARK: - Helpers
private extension Date {
    func adding(hours: Int) -> Date {
        return self.addingTimeInterval(3600 * Double(hours))
    }
}
