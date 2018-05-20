//
//  Created by Alex Shubin on 20/10/2017.
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import RxSwift
import RxCocoa

protocol Coordinator {
    init(window: UIWindow)

    /// Transition to another scene.
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void>

    /// Pop scene from navigation stack or dismiss current modal.
    @discardableResult
    func pop(animated: Bool, toRoot: Bool) -> Observable<Void>

    /// Show an alert or actionSheet.
    @discardableResult
    func show(alert: AlertActionSheet, animated: Bool) -> Observable<String?>
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

    private var window: UIWindow
    private var currentViewController: UIViewController

    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
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
            let viewController = scene.viewController
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onNext(())
        case .push:
            guard let navigationController = (currentViewController as? UINavigationController)
                ?? currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            let viewController = scene.viewController
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
        case .modal:
            let viewController = scene.viewController
            currentViewController.present(viewController, animated: true) {
                subject.onNext(())
            }
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
        }
        return subject
    }

    @discardableResult
    func pop(animated: Bool, toRoot: Bool) -> Observable<Void> {
        if let presenter = currentViewController.presentingViewController {
            let subject = PublishSubject<Void>()
            // dismiss a modal controller
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onNext(())
            }
            return subject
        } else if currentViewController.navigationController != nil {
            guard let navigationController = currentViewController.navigationController else {
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
                    fatalError("can't navigate back from \(currentViewController)")
                }
            } else {
                guard navigationController.popViewController(animated: false) != nil else {
                    fatalError("can't navigate back from \(currentViewController)")
                }
            }
            currentViewController =
                SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
            return subject
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
    }

    /// Show an alert or actionSheet.
    @discardableResult
    func show(alert: AlertActionSheet, animated: Bool) -> Observable<String?> {
        switch alert {
        case let .alert(data: data, textField: textField):
            return Single
                .create { [unowned self] single in
                    let alertController = UIAlertController(title: data.title,
                                                            message: data.message,
                                                            preferredStyle: .alert)
                    if textField != nil {
                        alertController.addTextField(configurationHandler: textField)
                    }
                    data.actions
                        .map { action in
                            return UIAlertAction(title: action.title, style: action.style) {
                                action.handler?($0)
                                single(.success(alertController.textFields?.first?.text))
                            }
                        }.forEach {
                            alertController.addAction($0)
                        }
                    self.currentViewController.present(alertController, animated: animated)
                    return Disposables.create()
                }
                .asObservable()
        case let .actionSheet(data: data, sender: sender):
            return Single
                .create { [unowned self] single in

                    let actionSheet = UIAlertController(title: data.title,
                                                        message: data.message,
                                                        preferredStyle: .actionSheet)
                    data.actions
                        .map { action in
                            return UIAlertAction(title: action.title, style: action.style) {
                                action.handler?($0)
                                single(.success(nil))
                            }
                        }
                        .forEach {
                            actionSheet.addAction($0)
                        }
                    actionSheet.popoverPresentationController?.sourceView = sender
                    actionSheet.popoverPresentationController?.sourceRect = sender.bounds
                    self.currentViewController.present(actionSheet, animated: animated)
                    return Disposables.create()
                }
                .asObservable()
        }
    }
}
