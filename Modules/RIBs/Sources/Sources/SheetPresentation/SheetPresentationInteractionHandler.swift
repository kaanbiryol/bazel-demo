import UIKit

public protocol SheetPresentationInteractionHandlerDelegate: AnyObject {
    func sheetPresentationControllerDidMove(presentedView: UIView, in containerView: UIView?)
    func sheetPresentationControllerWillPresent()
}

extension SheetPresentationInteractionHandlerDelegate {
    public func sheetPresentationControllerDidMove(presentedView: UIView, in containerView: UIView?) {}
    public func sheetPresentationControllerWillPresent() {}
}

public final class SheetPresentationInteractionHandler: NSObject, UISheetPresentationControllerDelegate {
    private var observation: NSKeyValueObservation?

    public weak var delegate: SheetPresentationInteractionHandlerDelegate?

    deinit {
        observation = nil
    }

    public func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            if let presentedView = presentationController.presentedView {
                // [Programmatic animated sheet updates] Update position once alongside transition
                self?.delegate?.sheetPresentationControllerDidMove(presentedView: presentedView, in: presentationController.containerView)
                self?.delegate?.sheetPresentationControllerWillPresent()

                // [Interactive sheet updates] Set up KVO of presentedView.frame
                self?.observation = presentationController.presentedView?.observe(\.frame) { [containerView = presentationController.containerView] view, _ in
                    self?.delegate?.sheetPresentationControllerDidMove(presentedView: view, in: containerView)
                }
            }
        })
    }
}
