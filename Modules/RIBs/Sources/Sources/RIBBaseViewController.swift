import UIKit

/// A base view controller that ensures calling a ``didNavigateBack()`` method when navigating back with any gesture
/// i.e. swiping down to dismiss a sheet presentation or swiping from the screen edge to go back.
///
/// - warning: Any subclass MUST override the ``didNavigateBack()`` method, otherwise calling this method will
///   throw a fatal error. See documentation of ``didNavigateBack()`` for details.
open class RIBBaseViewController: UIViewController {
    public let subtitle: String?
    public init(title: String? = nil, subtitle: String? = nil) {
        self.subtitle = subtitle
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        setPresentationControllerDelegate()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setPresentationControllerDelegate()
    }

    override open func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if parent == nil {
            didNavigateBack()
        }
    }

    /// This method will be called when navigating back with any gesture i.e. swiping down to dismiss a
    /// sheet presentation or swiping from the screen edge to go back.
    ///
    /// As this base view controller is meant to be implemented in a RIB context, overriding the method should
    /// trivially forward to the listener method with the same name.
    ///
    /// ```swift
    /// override func didNavigateBack() {
    ///     listener?.didNavigateBack()
    /// }
    /// ```
    ///
    /// By annotating the override with `@objc` it is even possible to use it as a selector for a UIControl action.
    ///
    /// ```swift
    ///
    /// private func setup() {
    ///     navigationItem.leftBarButtonItem = .closeButton(theme: theme, target: self, action: #selector(didNavigateBack))
    /// }
    ///
    /// @objc
    /// override func didNavigateBack() {
    ///     listener?.didNavigateBack()
    /// }
    /// ```
    open func didNavigateBack() {
        // If the app crashes here, open the Debug Area, check the for the type of `self` and implement
        // an override for this method in the subclass as described in the documentation of this method.
        fatalError("didNavigateBack() has not been implemented in '\(type(of: self))'")
    }

    /// Set `self` as the delegate of the current presentation controller.
    private func setPresentationControllerDelegate() {
        // If we are setting the presentationController?.delegate when we are embedded
        // in any kind of container view controller, we will create a retain cycle
        // https://forums.developer.apple.com/thread/132994
        if parent == nil, !isMovingToParent, modalPresentationStyle != .none, presentationController?.delegate !== self {
            if let oldDelegate = presentationController?.delegate, oldDelegate !== self {
//                logger.warning("Replacing existing presentationController.delegate \(String(describing: oldDelegate)) with \(String(describing: self))")
            }
            presentationController?.delegate = self
        } else if parent === navigationController, modalPresentationStyle != .none, navigationController?.presentationController?.delegate !== self {
            if let oldDelegate = navigationController?.presentationController?.delegate, oldDelegate !== self {
//                logger.warning("Replacing existing presentationController.delegate \(String(describing: oldDelegate)) with \(String(describing: self))")
            }
            navigationController?.presentationController?.delegate = self
        }
    }
}

// MARK: - UISheetPresentationControllerDelegate

extension RIBBaseViewController: UISheetPresentationControllerDelegate {
    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        didNavigateBack()
    }
}
