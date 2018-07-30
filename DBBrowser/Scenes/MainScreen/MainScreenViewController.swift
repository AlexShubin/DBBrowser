//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {

    let bag = DisposeBag()

    private let _converter: MainScreenViewStateConverter

    private let _fromCaption = UILabel()
    private let _fromLabel = UILabel()
    private let _dateCaption = UILabel()
    private let _dateLabel = UILabel()
    private let _searchButton = UIButton(type: .system)

    init(converter: MainScreenViewStateConverter) {
        _converter = converter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupLayout()

        view.backgroundColor = .white

        _fromCaption.text = L10n.MainScreen.stationCaption
        _dateCaption.text = L10n.MainScreen.dateCaption

        _fromLabel.font = Constants.Fonts.inputLabels
        _fromLabel.isUserInteractionEnabled = true
        _dateLabel.font = Constants.Fonts.inputLabels
        _dateLabel.textColor = .black

        _searchButton.backgroundColor = UIColor(asset: Asset.Colors.dbRed)
        _searchButton.layer.cornerRadius = 8
        _searchButton.setTitle(L10n.MainScreen.searchButton, for: .normal)
        _searchButton.tintColor = .white
    }

    private func _setupLayout() {
        // Image view
        let imageView = UIImageView(image: UIImage(asset: Asset.mainScreenImage))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        // Sheet view
        let sheetView = UIView()
        sheetView.layer.cornerRadius = 24
        sheetView.backgroundColor = .white
        view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -24),
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        // Station stack view
        let stationStack = UIStackView(arrangedSubviews: [_fromCaption, _fromLabel])
        stationStack.axis = .vertical
        stationStack.spacing = 6
        // Date stack view
        let dateStack = UIStackView(arrangedSubviews: [_dateCaption, _dateLabel])
        dateStack.axis = .vertical
        dateStack.spacing = 6
        // Search button
        _searchButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        // Stack view
        let stack = UIStackView(arrangedSubviews: [stationStack, dateStack, _searchButton])
        stack.axis = .vertical
        stack.spacing = 24
        sheetView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: sheetView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24)
            ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - StateStoreBindable
extension MainScreenViewController: StateStoreBindable {
    func subscribe(to stateStore: StateStore) {
        // State to view state conversion
        let viewState: Signal<MainScreenViewState> = stateStore
            .stateBus
            .distinctUntilChanged()
            .flatMap { [weak self] in
                if let viewState = self?._converter.convert(from: $0) {
                    return .just(viewState)
                }
                return .empty()
        }
        // State render
        viewState
            .emit(onNext: { [weak self] in
                self?._render($0)
            })
            .disposed(by: bag)
        // UI Events
        let fromLabelRecognizer = UITapGestureRecognizer()
        _fromLabel.addGestureRecognizer(fromLabelRecognizer)
        fromLabelRecognizer.rx.event
            .map { _ in
                .coordinator(.show(.stationSearch, .modal))
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        _searchButton.rx.tap
            .map {
                .coordinator(.show( .timetable, .push))
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }

    private func _render(_ state: MainScreenViewState) {
        _render(field: state.station, in: _fromLabel)
        _dateLabel.text = state.date
    }

    private func _render(field: MainScreenViewState.Field, in label: UILabel) {
        switch field {
        case .placeholder(let str):
            label.text = str
            label.textColor = .lightGray
        case .chosen(let str):
            label.text = str
            label.textColor = .black
        }
    }
}

private extension MainScreenViewController {
    enum Constants {
        enum Fonts {
            static let inputLabels = UIFont.systemFont(ofSize: 34, weight: .medium)
        }
    }
}
