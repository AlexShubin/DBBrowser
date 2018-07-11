//
//  Created by Alex Shubin on 20/10/2017.
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SceneCoordinatorType {
    @discardableResult
    func push(scene: Scene) -> Observable<Void>

    @discardableResult
    func present(scene: Scene) -> Observable<Void>

    @discardableResult
    func setRoot(scene: Scene) -> Observable<Void>

    @discardableResult
    func pop() -> Observable<Void>

    @discardableResult
    func dismiss() -> Observable<Void>
}

struct SceneCoordinator: SceneCoordinatorType {
    private let _viewControllerFactory: ViewControllerFactory
    private let _navigationController = UINavigationController()

    init(window: UIWindow, viewControllerFactory: ViewControllerFactory) {
        window.rootViewController = _navigationController
        _viewControllerFactory = viewControllerFactory
    }

    func push(scene: Scene) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let vc = _viewControllerFactory.make(scene)
        // one-off subscription to be notified when push complete
        _ = _navigationController.rx.delegate
            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in }
            .bind(to: subject)
        _navigationController.pushViewController(vc, animated: true)
        return subject
    }

    func present(scene: Scene) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let vc = _viewControllerFactory.make(scene)
        vc.modalPresentationStyle = .overFullScreen
        _navigationController.present(vc, animated: true) {
            subject.onNext(())
        }
        return subject
    }

    func setRoot(scene: Scene) -> Observable<Void> {
        let vc = _viewControllerFactory.make(scene)
        _navigationController.setViewControllers([vc], animated: false)
        return .just(())
    }

    func pop() -> Observable<Void> {
        let subject = PublishSubject<Void>()
        // navigate up the stack
        // one-off subscription to be notified when pop complete
        _ = _navigationController.rx.delegate
            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in }
            .take(1)
            .bind(to: subject)
        guard _navigationController.popViewController(animated: false) != nil else {
            fatalError("Can't navigate back")
        }
        return subject
    }

    func dismiss() -> Observable<Void> {
        let subject = PublishSubject<Void>()
        _navigationController.presentedViewController?.view.endEditing(true)
        _navigationController.dismiss(animated: true) {
            subject.onNext(())
        }
        return subject
    }
}
