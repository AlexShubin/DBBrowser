//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional

class StationSearchViewController: UIViewController {
    
    let bag = DisposeBag()
    
    private let _converter: StationSearchViewStateConverter
    
    private let _containerView = UILabel()
    private let _inputField = UITextField()
    private let _tableView = UITableView(frame: .zero, style: .grouped)
    
    init(converter: StationSearchViewStateConverter) {
        _converter = converter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupViewHierarchy()
        _setupUI()
        _tableView.registerCell(ofType: StationCell.self)
    }
    
    private func _setupUI() {
        _containerView.backgroundColor = .white
        _inputField.borderStyle = .roundedRect
        _inputField.placeholder = "enter text"
        _inputField.isUserInteractionEnabled = true
        _containerView.isUserInteractionEnabled = true
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.estimatedRowHeight = 40
    }
    
    private func _setupViewHierarchy() {
        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = view.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = view.topAnchor
        }
        view.addSubview(_containerView)
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _containerView.topAnchor.constraint(equalTo: topAnchor),
            _containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        _containerView.addSubview(_inputField)
        _inputField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _inputField.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: 16),
            _inputField.leadingAnchor.constraint(equalTo: _containerView.leadingAnchor, constant: 16),
            _inputField.trailingAnchor.constraint(equalTo: _containerView.trailingAnchor, constant: -16),
            _inputField.heightAnchor.constraint(equalToConstant: 32)
            ])
        _containerView.addSubview(_tableView)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _tableView.topAnchor.constraint(equalTo: _inputField.bottomAnchor, constant: 10),
            _tableView.leadingAnchor.constraint(equalTo: _containerView.leadingAnchor),
            _tableView.trailingAnchor.constraint(equalTo: _containerView.trailingAnchor),
            _tableView.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor)
            ])
    }
}

extension StationSearchViewController: StateStoreBindable {
    func subscribe(to stateStore: StateStore) {
        let viewState: Signal<StationSearchViewState> = stateStore
            .stateBus
            .map { $0.stationSearch }
            .distinctUntilChanged()
            .flatMap { [weak self] in
                if let viewState = self?._converter.convert(state: $0) {
                    return .just(viewState)
                }
                return .empty()
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<StationSearchViewState.Section>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell: StationCell = tableView.dequeueReusableCell(for: indexPath)
                cell.render(state: item)
                return cell
        }
        )
        
        viewState
            .map { $0.sections }
            .asObservable()
            .bind(to: _tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        _inputField.rx
            .text
            .filterNil()
            .filterEmpty()
            .throttle(1, scheduler: MainScheduler.instance)
            .map { AppEvent.stationSearch(.search($0)) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        
    }
}
