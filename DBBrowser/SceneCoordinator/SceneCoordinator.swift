//
//  Created by Alex Shubin on 20/10/2017.
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import RxSwift
import RxCocoa

protocol Coordinator {
    /// Transition to another scene.
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void>

    /// Pop scene from navigation stack or dismiss current modal.
    @discardableResult
    func pop(animated: Bool, toRoot: Bool) -> Observable<Void>
}

extension Coordinator {
    @discardableResult
    func popToRoot() -> Observable<Void> {
        return pop(animated: true, toRoot: true)
    }
    
    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true, toRoot: false)
    }
}

class SceneCoordinator: Coordinator {

    private let _window: UIWindow
    private let _viewControllerFactory: ViewControllerFactory
    private var _currentViewController: UIViewController

    required init(window: UIWindow, viewControllerFactory: ViewControllerFactory) {
        _window = window
        _currentViewController = window.rootViewController!
        _viewControllerFactory = viewControllerFactory
    }

    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        let vc: UIViewController
        if let tabBarController = viewController as? UITabBarController {
            vc = tabBarController.viewControllers![tabBarController.selectedIndex]
        } else {
            vc = viewController
        }
        if let navigationController = vc as? UINavigationController {
            return navigationController.viewControllers.last!
        } else {
            return vc
        }
    }

    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        switch type {
        case .root:
            let viewController = _viewControllerFactory.make(scene)
            _currentViewController = SceneCoordinator.actualViewController(for: viewController)
            _window.rootViewController = viewController
            subject.onNext(())
        case .push:
            guard let navigationController = (_currentViewController as? UINavigationController)
                ?? _currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            let viewController = _viewControllerFactory.make(scene)
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
            _currentViewController = SceneCoordinator.actualViewController(for: viewController)
        case .modal:
            let viewController = _viewControllerFactory.make(scene)
            viewController.modalPresentationStyle = .overFullScreen
            _currentViewController.present(viewController, animated: true) {
                subject.onNext(())
            }
            _currentViewController = SceneCoordinator.actualViewController(for: viewController)
        }
        return subject
    }

    @discardableResult
    func pop(animated: Bool, toRoot: Bool) -> Observable<Void> {
        if let presenter = _currentViewController.presentingViewController {
            let subject = PublishSubject<Void>()
            // dismiss a modal controller
            _currentViewController.dismiss(animated: animated) {
                self._currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onNext(())
            }
            return subject
        } else if _currentViewController.navigationController != nil {
            guard let navigationController = _currentViewController.navigationController else {
                return .just(())
            }
            let subject = PublishSubject<Void>()
            // navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .take(1)
                .bind(to: subject)
            if toRoot {
                guard navigationController.popToRootViewController(animated: false) != nil else {
                    fatalError("can't navigate back from \(_currentViewController)")
                }
            } else {
                guard navigationController.popViewController(animated: false) != nil else {
                    fatalError("can't navigate back from \(_currentViewController)")
                }
            }
            _currentViewController =
                SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
            return subject
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(_currentViewController)")
        }
    }
}
