import Combine
import UIKit

/// The root `Router` of an application.
/// @mockable
public protocol LaunchRouting: ViewableRouting {
    /// A publisher that emits values when Rib node changes. This
    /// publisher never completes.
    var routerTreeDidChange: AnyPublisher<Void, Never> { get }

    /// Launches the router tree.
    ///
    /// - parameter window: The application window to launch from.
    func launch(from window: UIWindow)
}

/// The application root router base class, that acts as the root of the router tree.
open class LaunchRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>, LaunchRouting {
    public var routerTreeDidChange: AnyPublisher<Void, Never> {
        routerTreeDidChangeSubject!.eraseToAnyPublisher() // swiftlint:disable:this force_unwrapping
    }

    /// Initializer.
    ///
    /// - parameter interactor: The corresponding `Interactor` of this `Router`.
    /// - parameter viewController: The corresponding `ViewController` of this `Router`.
    override public init(interactor: InteractorType, viewController: ViewControllerType) {
        super.init(interactor: interactor, viewController: viewController)
        routerTreeDidChangeSubject = CurrentValueSubject<Void, Never>(())
    }

    /// Launches the router tree.
    ///
    /// - parameter window: The window to launch the router tree in.
    public final func launch(from window: UIWindow) {
        window.rootViewController = viewControllable.uiViewController
        window.makeKeyAndVisible()

        interactable.activate()
        load()
    }
}
