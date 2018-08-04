//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

class MainScreenViewController: UIViewController {

    let bag = DisposeBag()

    private let _converter: MainScreenViewStateConverter

    private let _stationCaption = UILabel()
    private let _stationLabel = UILabel()
    private let _corrStationCaption = UILabel()
    private let _corrStationLabel = UILabel()
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

        _stationCaption.text = L10n.MainScreen.stationCaption
        _stationLabel.font = Constants.Fonts.inputLabels
        _stationLabel.isUserInteractionEnabled = true

        _corrStationCaption.text = L10n.MainScreen.corrStationCaption
        _corrStationLabel.font = Constants.Fonts.inputLabels
        _corrStationLabel.isUserInteractionEnabled = true

        _dateCaption.text = L10n.MainScreen.dateCaption
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
        let stationStack = UIStackView(arrangedSubviews: [_stationCaption, _stationLabel])
        stationStack.axis = .vertical
        stationStack.spacing = Constants.Field.spacing
        // Corr station stack view
        let corrStationStack = UIStackView(arrangedSubviews: [_corrStationCaption, _corrStationLabel])
        corrStationStack.axis = .vertical
        corrStationStack.spacing = Constants.Field.spacing
        // Date stack view
        let dateStack = UIStackView(arrangedSubviews: [_dateCaption, _dateLabel])
        dateStack.axis = .vertical
        dateStack.spacing = Constants.Field.spacing
        // Search button
        _searchButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        // Stack view
        let stack = UIStackView(arrangedSubviews: [stationStack, dateStack, corrStationStack, _searchButton])
        stack.axis = .vertical
        stack.spacing = Constants.FieldsStack.spacing
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
            .map { $0.timetable }
            .distinctUntilChanged()
            .map { [weak self] in self?._converter.convert(from: $0) }
            .filterNil()
        // State render
        viewState
            .emit(onNext: { [weak self] in
                self?._render($0)
            })
            .disposed(by: bag)
        // UI Events
        let stationLabelRecognizer = UITapGestureRecognizer()
        _stationLabel.addGestureRecognizer(stationLabelRecognizer)
        stationLabelRecognizer.rx.event
            .flatMap { _ in
                Observable.of(
                    .stationSearch(.mode(.station)),
                    .coordinator(.show(.stationSearch, .modal))
                )
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        let corrStationLabelRecognizer = UITapGestureRecognizer()
        _corrStationLabel.addGestureRecognizer(corrStationLabelRecognizer)
        corrStationLabelRecognizer.rx.event
            .flatMap { _ in
                Observable.of(
                    .stationSearch(.mode(.corrStation)),
                    .coordinator(.show(.stationSearch, .modal))
                )
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        _searchButton.rx.tap
            .flatMap {
                Observable.of(.timetable(.reset),
                              .coordinator(.show(.timetable, .push)))
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }

    private func _render(_ state: MainScreenViewState) {
        _render(field: state.station, in: _stationLabel)
        _render(field: state.corrStation, in: _corrStationLabel)
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
        enum Field {
            static let spacing: CGFloat = 4
        }
        enum FieldsStack {
            static let spacing: CGFloat = 18
        }
    }
}
