//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional

class TimetableViewController: UIViewController {

    private typealias DataSource = RxTableViewSectionedReloadDataSource<TimetableViewState.Section>

    let bag = DisposeBag()

    private let _converter: TimetableViewStateConverter

    private let _tableView = UITableView(frame: .zero, style: .grouped)
    private let _segmentedControl = UISegmentedControl(items: [
            L10n.Timetable.SegmentedControl.departures,
            L10n.Timetable.SegmentedControl.arrivals
        ])

    init(converter: TimetableViewStateConverter) {
        _converter = converter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupLayout()

        _tableView.separatorStyle = .none
        _tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        _segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)],
                                                 for: .normal)

        _tableView.registerCell(ofType: TimetableEventCell.self)
        _tableView.registerCell(ofType: LoadingCell.self)
        _tableView.registerCell(ofType: ErrorCell.self)
        _tableView.registerCell(ofType: TimetableMoreCell.self)
    }

    private func _setupLayout() {
        view.addSubview(_tableView)
        _tableView.pinToSuperview()
        navigationItem.titleView = _segmentedControl
    }
}

// MARK: - StateStoreBindable
extension TimetableViewController: StateStoreBindable {
    func subscribe(to stateStore: StateStore) {
        // State to view state conversion
        let viewState: Signal<TimetableViewState> = stateStore
            .stateBus
            .map { $0.timetable }
            .distinctUntilChanged()
            .map { [weak self] in self?._converter.convert(from: $0) }
            .filterNil()

        // State render
        let dataSource = _dataSource(with: stateStore.eventBus)
        viewState.map { $0.sections }
            .asObservable()
            .bind(to: _tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        viewState.map { $0.segmentedControlIndex }
            .asObservable()
            .take(1)
            .bind(to: _segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: bag)

        // Bind UI
        rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in .timetable(.loadTimetable) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        _segmentedControl.rx.value
            .skip(1)
            .map { .timetable(.changeTable($0)) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }

    private func _dataSource(with eventBus: PublishRelay<AppEvent>) -> DataSource {
        return DataSource(configureCell: { _, tableView, indexPath, item in
            switch item {
            case .event(let cellState):
                let cell: TimetableEventCell = tableView.dequeueReusableCell(for: indexPath)
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
                            return .timetable(.loadTimetable)
                        }
                    }
                    .bind(to: eventBus)
                    .disposed(by: cell.bag)
                return cell
            case .loadMore(let cellState):
                let cell: TimetableMoreCell = tableView.dequeueReusableCell(for: indexPath)
                cell.render(state: cellState)
                cell.events
                    .map {
                        switch $0 {
                        case .moreTap:
                            return .timetable(.loadTimetable)
                        }
                    }
                    .bind(to: eventBus)
                    .disposed(by: cell.bag)
                return cell
            }
        })
    }
}
