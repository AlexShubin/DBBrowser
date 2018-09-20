//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

public protocol ToastManagerType {
    func show(_ toastType: ToastType)
}

public enum ToastType {
    case noInternetConnection
    case tryLater

    var toastViewState: ToastView.State {
        switch self {
        case .noInternetConnection:
            return ToastView.State(color: UIColor(asset: Asset.Colors.warningRed),
                                   text: "")
        case .tryLater:
            return ToastView.State(color: UIColor(asset: Asset.Colors.warningBlue),
                                   text: "")
        }
    }
}

public struct ToastManager: ToastManagerType {

    private enum Constants {
        static let toastHeight: CGFloat = 44
        enum Animation {
            static let duration = 0.25
            static let delay = 2.0
        }
    }

    private let _window: UIWindow

    public init(window: UIWindow) {
        _window = window
    }

    public func show(_ toastType: ToastType) {
        let toastView = ToastView()
        toastView.render(state: toastType.toastViewState)

        // Calcualte toast height
        var height = Constants.toastHeight
        if _window.safeAreaInsets.top > 0 {
            height += _window.safeAreaInsets.top
        }

        // Add starting constraints and layout
        _window.addSubview(toastView)
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: _window.leadingAnchor),
            toastView.trailingAnchor.constraint(equalTo: _window.trailingAnchor),
            toastView.heightAnchor.constraint(equalToConstant: height)
            ])

        let bottomAnchor = toastView.bottomAnchor.constraint(equalTo: _window.topAnchor)
        bottomAnchor.isActive = true
        _window.layoutIfNeeded()

        // Animate and remove
        UIView.animate(withDuration: Constants.Animation.duration, animations: {
            bottomAnchor.constant = height
            self._window.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: Constants.Animation.duration,
                           delay: Constants.Animation.delay,
                           options: [],
                           animations: {
                            bottomAnchor.constant = 0
                            self._window.layoutIfNeeded()
            },
                           completion: { _ in
                            toastView.removeFromSuperview()
            })
        })
    }
}
