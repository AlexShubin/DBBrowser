//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {

    let bag = DisposeBag()

    private let _converter: MainScreenViewStateConverter

    private let _fromLabelCaption = UILabel()
    private let _fromLabel = UILabel()
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

        _fromLabelCaption.text = L10n.MainScreen.stationCaption

        _fromLabel.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        _fromLabel.isUserInteractionEnabled = true

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
        let stationStack = UIStackView(arrangedSubviews: [_fromLabelCaption, _fromLabel])
        stationStack.axis = .vertical
        stationStack.spacing = 6
        // Search button
        _searchButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        // Stack view
        let stack = UIStackView(arrangedSubviews: [stationStack, _searchButton])
        stack.axis = .vertical
        stack.spacing = 24
        sheetView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant: -24),
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
        let tgr = UITapGestureRecognizer()
        _fromLabel.addGestureRecognizer(tgr)
        tgr.rx.event
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
        switch state.station {
        case .placeholder(let str):
            _fromLabel.text = str
            _fromLabel.textColor = .lightGray
        case .chosen(let str):
            _fromLabel.text = str
            _fromLabel.textColor = .black
        }
    }
}
