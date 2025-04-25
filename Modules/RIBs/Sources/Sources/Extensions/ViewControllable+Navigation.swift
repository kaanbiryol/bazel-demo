import UIKit

extension ViewControllable {
    public func presentViewController(_ viewController: ViewControllable, animated: Bool = true, prefersLargeTitles: Bool? = nil, completion: (() -> Void)? = nil) {
        guard let prefersLargeTitles else {
            uiViewController.present(viewController.uiViewController, animated: animated, completion: completion)
            return
        }
        if viewController.uiViewController is UINavigationController {
            uiViewController.present(viewController.uiViewController, animated: animated, completion: completion)
        } else {
            let navigationController = UINavigationController(rootViewController: viewController.uiViewController)
            navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
            uiViewController.present(navigationController, animated: animated, completion: completion)
        }
    }

    public func presentViewController(_ viewController: ViewControllable) {
        uiViewController.present(viewController.uiViewController, animated: true, completion: nil)
    }

    /// Provides UISheetPresentationController features plus the ability of showing a decoration view on top of the bottom sheet.
    public func presentViewControllerAsSheet(
        _ viewController: ViewControllable,
        configuration: SheetConfiguration = .default,
        animated: Bool = true,
        embedInNavigationController: Bool = false,
        delegate: UISheetPresentationControllerDelegate? = nil,
        completion: (() -> Void)? = nil
    ) {
        var viewControllerToPresent = viewController.uiViewController
        if embedInNavigationController, !(viewController.uiViewController is UINavigationController) {
            let navigationController = UINavigationController(rootViewController: viewController.uiViewController)
            navigationController.navigationBar.prefersLargeTitles = true
            viewControllerToPresent = navigationController
        }

        if let sheet = viewControllerToPresent.sheetPresentationController {
            viewControllerToPresent.modalPresentationStyle = .pageSheet
            sheet.prefersGrabberVisible = configuration.prefersGrabberVisible
            sheet.detents = configuration.detents
            sheet.selectedDetentIdentifier = configuration.selectedDetentIdentifier
            sheet.largestUndimmedDetentIdentifier = configuration.largestUndimmedDetentIdentifier
            sheet.prefersScrollingExpandsWhenScrolledToEdge = configuration.prefersScrollingExpandsWhenScrolledToEdge
            sheet.preferredCornerRadius = configuration.preferredCornerRadius
            if let delegate {
                sheet.delegate = delegate
            }
        }

        uiViewController.present(viewControllerToPresent, animated: animated, completion: completion)
    }

    public func dismissViewController(_ viewController: ViewControllable, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard uiViewController.presentedViewController === viewController.uiViewController ||
            (uiViewController.presentedViewController as? UINavigationController)?.topViewController === viewController.uiViewController
        else {
            completion?()
            return
        }
        uiViewController.dismiss(animated: animated, completion: completion)
    }

    public func dismissViewController(_ viewController: ViewControllable) {
        dismissViewController(viewController, animated: true)
    }

    public func pushViewController(_ viewController: ViewControllable) {
        uiViewController.navigationController?.pushViewController(viewController.uiViewController, animated: true)
    }

    public func popViewController(_ viewController: ViewControllable) {
        guard uiViewController.navigationController?.topViewController === viewController.uiViewController else { return }
        uiViewController.navigationController?.popViewController(animated: true)
    }
}
