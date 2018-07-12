//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional

class StationSearchViewController: UIViewController {

    private typealias DataSource = RxTableViewSectionedReloadDataSource<StationSearchViewState.Section>

    let bag = DisposeBag()

    private let _converter: StationSearchViewStateConverter

    private let _containerView = RoundedView()
    private let _searchBar = UISearchBar()
    private let _tableView = UITableView()

    init(converter: StationSearchViewStateConverter) {
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

        _containerView.backgroundColor = .white
        _containerView.roundedCorners = [.topLeft, .topRight]
        _containerView.cornerRadius = 16
        _containerView.addBottomSeparator()
        _searchBar.searchBarStyle = .minimal
        _searchBar.showsCancelButton = true
        _searchBar.placeholder = L10n.StationSearch.placeholder
        _containerView.isUserInteractionEnabled = true
        _tableView.separatorStyle = .none

        _tableView.registerCell(ofType: StationCell.self)
        _tableView.registerCell(ofType: LoadingCell.self)
        _tableView.registerCell(ofType: ErrorCell.self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _searchBar.becomeFirstResponder()
    }

    private func _setupLayout() {
        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = view.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = view.topAnchor
        }
        view.addSubview(_containerView)
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _containerView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            _containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        _containerView.addSubview(_searchBar)
        _searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _searchBar.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: 16),
            _searchBar.leadingAnchor.constraint(equalTo: _containerView.leadingAnchor, constant: 8),
            _searchBar.trailingAnchor.constraint(equalTo: _containerView.trailingAnchor, constant: -8),
            _searchBar.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor, constant: -16)
            ])
        view.addSubview(_tableView)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _tableView.topAnchor.constraint(equalTo: _containerView.bottomAnchor),
            _tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

// MARK: - StateStoreBindable
extension StationSearchViewController: StateStoreBindable {
    func subscribe(to stateStore: StateStore) {
        // State to view state conversion
        let viewState: Signal<StationSearchViewState> = stateStore
            .stateBus
            .map { $0.stationSearch }
            .distinctUntilChanged()
            .flatMap { [weak self] in
                if let viewState = self?._converter.convert(from: $0) {
                    return .just(viewState)
                }
                return .empty()
        }

        // State render
        let dataSource = _dataSource(with: stateStore.eventBus)
        viewState
            .map { $0.sections }
            .asObservable()
            .bind(to: _tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        // UI Events
        _searchBar.rx
            .text
            .filterNil()
            .filterEmpty()
            .throttle(1, scheduler: MainScheduler.instance)
            .flatMap {
                Observable.of(.stationSearch(.searchString($0)),
                              .stationSearch(.startSearch))
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        _tableView.rx
            .itemSelected
            .map {
                .stationSearch(.selected($0.row))
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        _searchBar.rx
            .cancelButtonClicked
            .map {
                .stationSearch(.close)
            }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }

    private func _dataSource(with eventBus: PublishRelay<AppEvent>) -> DataSource {
        return DataSource(configureCell: { _, tableView, indexPath, item in
            switch item {
            case .station(let cellState):
                let cell: StationCell = tableView.dequeueReusableCell(for: indexPath)
                cell.render(state: cellState)
                return cell
            case .loading:
                let cell: LoadingCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            case .error:
                let cell: ErrorCell = tableView.dequeueReusableCell(for: indexPath)
                cell.events
                    .map {
                        switch $0 {
                        case .retryTap:
                            return .stationSearch(.startSearch)
                        }
                    }
                    .bind(to: eventBus)
                    .disposed(by: cell.bag)
                return cell
            }
        })
    }
}
