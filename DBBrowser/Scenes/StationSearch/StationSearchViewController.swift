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
    private let _inputField = UISearchBar()
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
        _inputField.searchBarStyle = .minimal
        _inputField.showsCancelButton = true
        _inputField.placeholder = L10n.StationSearch.placeholder
        _containerView.isUserInteractionEnabled = true
        _tableView.separatorStyle = .none
        
        _tableView.registerCell(ofType: StationCell.self)
        _tableView.registerCell(ofType: StationSearchLoadingCell.self)
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    var initialTouchPointY: CGFloat = 0
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPointY = sender.location(in: view?.window).y
        switch sender.state {
        case .began:
            initialTouchPointY = touchPointY
        case .changed:
            if touchPointY > initialTouchPointY {
                view.frame.origin.y = touchPointY - initialTouchPointY
            }
        case .ended, .cancelled:
            if touchPointY - initialTouchPointY > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _inputField.becomeFirstResponder()
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
        _containerView.addSubview(_inputField)
        _inputField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _inputField.topAnchor.constraint(equalTo: _containerView.topAnchor, constant: 16),
            _inputField.leadingAnchor.constraint(equalTo: _containerView.leadingAnchor, constant: 8),
            _inputField.trailingAnchor.constraint(equalTo: _containerView.trailingAnchor, constant: -8),
            _inputField.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor, constant: -16)
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
        
        let dataSource = DataSource(configureCell: { _, tableView, indexPath, item in
            switch item {
            case .station(let cellState):
                let cell: StationCell = tableView.dequeueReusableCell(for: indexPath)
                cell.render(state: cellState)
                return cell
            case .loading:
                let cell: StationSearchLoadingCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            case .error:
                return UITableViewCell()
            }
        })
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
