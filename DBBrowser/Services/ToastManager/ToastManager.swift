//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

public protocol ToastManagerType {
    func show(_ toastType: ToastType)
}

public enum ToastType {
    case unknownError
    case tryLaterError

    var toastViewState: ToastView.State {
        switch self {
        case .unknownError:
            return ToastView.State(color: UIColor(asset: Asset.Colors.warningRed),
                                   text: L10n.loadingError)
        case .tryLaterError:
            return ToastView.State(color: UIColor(asset: Asset.Colors.warningBlue),
                                   text: L10n.tryLaterError)
        }
    }
}

public struct ToastManager: ToastManagerType {

    private enum Constants {
        static let toastHeight: CGFloat = 43
        enum Animation {
            static let duration = 0.25
            static let delay = 2.0
        }
    }

    private let _application: UIApplication

    public init(application: UIApplication) {
        _application = application
    }

    public func show(_ toastType: ToastType) {
        DispatchQueue.main.async {
            guard let window = self._application.keyWindow else { return }
            self._show(toastType, in: window)
        }
    }

    private func _show(_ toastType: ToastType, in window: UIWindow) {
        let toastView = ToastView()
        toastView.render(state: toastType.toastViewState)

        // Calcualte toast height
        var height = Constants.toastHeight
        if window.safeAreaInsets.top > 0 {
            height += window.safeAreaInsets.top
        } else {
            height += _application.statusBarFrame.size.height
        }

        // Add starting constraints and layout
        window.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            toastView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            toastView.heightAnchor.constraint(equalToConstant: height)
            ])

        let bottomAnchor = toastView.bottomAnchor.constraint(equalTo: window.topAnchor)
        bottomAnchor.isActive = true
        window.layoutIfNeeded()

        // Animate and remove
        UIView.animate(withDuration: Constants.Animation.duration, animations: {
            bottomAnchor.constant = height
            window.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: Constants.Animation.duration,
                           delay: Constants.Animation.delay,
                           options: [],
                           animations: {
                            bottomAnchor.constant = 0
                            window.layoutIfNeeded()
            },
                           completion: { _ in
                            toastView.removeFromSuperview()
            })
        })
    }
}
