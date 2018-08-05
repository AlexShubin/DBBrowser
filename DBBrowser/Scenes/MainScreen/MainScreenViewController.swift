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

    private let _station = InputField()
    private let _corrStation = InputField()
    private let _date = InputField()
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
        // Search button
        _searchButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        // Stack view
        let stack = UIStackView(arrangedSubviews: [_station, _date, _corrStation, _searchButton])
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
        _station.events
            .flatMap { (event) -> Observable<AppEvent> in
                switch event {
                case .tap:
                    return .of(
                        .stationSearch(.mode(.station)),
                        .coordinator(.show(.stationSearch, .modal))
                    )
                }
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        _corrStation.events
            .flatMap { (event) -> Observable<AppEvent> in
                switch event {
                case .tap:
                    return .of(
                        .stationSearch(.mode(.corrStation)),
                        .coordinator(.show(.stationSearch, .modal))
                    )
                }
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
        _station.render(state: state.station)
        _corrStation.render(state: state.corrStation)
        _date.render(state: state.date)
    }
}

// MARK: - Constants

private extension MainScreenViewController {
    enum Constants {
        enum FieldsStack {
            static let spacing: CGFloat = 18
        }
    }
}
