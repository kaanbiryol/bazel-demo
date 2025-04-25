import Combine

/// Protocol defining the activeness of an interactor's scope.
/// @mockable(combine: isActivePublisher = CurrentValueSubject)
public protocol InteractorScope: AnyObject {
    // The following properties must be declared in the base protocol, since `Router` internally invokes these methods.
    // In order to unit test router with a mock interactor, the mocked interactor first needs to conform to the custom
    // subclass interactor protocol, and also this base protocol to allow the `Router` implementation to execute base
    // class logic without error.

    /// Indicates if the interactor is active.
    var isActive: Bool { get }

    /// The lifecycle of this interactor.
    ///
    /// - note: Subscription to this publisher always immediately returns the last event. This publisher completes after
    ///   the interactor is deallocated.
    var isActivePublisher: AnyPublisher<Bool, Never> { get }
}

/// The base protocol for all interactors.
/// @mockable
public protocol Interactable: InteractorScope {
    // The following methods must be declared in the base protocol, since `Router` internally invokes these methods.
    // In order to unit test router with a mock interactor, the mocked interactor first needs to conform to the custom
    // subclass interactor protocol, and also this base protocol to allow the `Router` implementation to execute base
    // class logic without error.

    /// Activate this interactor.
    ///
    /// - note: This method is internally invoked by the corresponding router. Application code should never explicitly
    ///   invoke this method.
    func activate()

    /// Deactivate this interactor.
    ///
    /// - note: This method is internally invoked by the corresponding router. Application code should never explicitly
    ///   invoke this method.
    func deactivate()
}

/// An `Interactor` defines a unit of business logic that corresponds to a router unit.
///
/// An `Interactor` has a lifecycle driven by its owner router. When the corresponding router is attached to its
/// parent, its interactor becomes active. And when the router is detached from its parent, its `Interactor` resigns
/// active.
///
/// An `Interactor` should only perform its business logic when it's currently active.
open class Interactor: Interactable {
    /// Indicates if the interactor is active.
    public final var isActive: Bool {
        isActiveSubject.value
    }

    /// A publisher notifying on the lifecycle of this interactor.
    public final var isActivePublisher: AnyPublisher<Bool, Never> {
        isActiveSubject.removeDuplicates().eraseToAnyPublisher()
    }

    private var isActiveSubject = CurrentValueSubject<Bool, Never>(false)

    fileprivate var cancellables: [AnyCancellable]?

    /// Initializer.
    public init() {
        // No-op
    }

    deinit {
        if isActive {
            deactivate()
        }
    }

    /// Activate the `Interactor`.
    ///
    /// - note: This method is internally invoked by the corresponding router. Application code should never explicitly
    ///   invoke this method.
    public final func activate() {
        guard !isActive else {
            return
        }

//        logger.trace("\(String(describing: self), privacy: .public) is becoming active")

        cancellables = [AnyCancellable]()
        isActiveSubject.value = true
        didBecomeActive()
    }

    /// The interactor did become active.
    ///
    /// - note: This method is driven by the attachment of this interactor's owner router. Subclasses should override
    ///   this method to setup subscriptions and initial states.
    open func didBecomeActive() {
        // No-op
    }

    /// Deactivate this `Interactor`.
    ///
    /// - note: This method is internally invoked by the corresponding router. Application code should never explicitly
    ///   invoke this method.
    public final func deactivate() {
        guard isActive else {
            return
        }

//        logger.trace("\(String(describing: self), privacy: .public) will resign active")

        willResignActive()

        cancellables?.removeAll()
        cancellables = nil

        isActiveSubject.value = false
    }

    /// Callend when the `Interactor` will resign the active state.
    ///
    /// This method is driven by the detachment of this interactor's owner router. Subclasses should override this
    /// method to cleanup any resources and states of the `Interactor`. The default implementation does nothing.
    open func willResignActive() {
        // No-op
    }
}

/// Interactor related `Publisher` extensions.
extension Publisher where Failure == Never {
    /// Confines the publisher's subscription to the given interactor scope. The subscription is only triggered
    /// after the interactor scope is active and before the interactor scope resigns active. This composition
    /// delays the subscription but does not dispose the subscription, when the interactor scope becomes inactive.
    ///
    /// - note: This method should only be used for subscriptions outside of an `Interactor`, for cases where a
    ///   piece of logic is only executed when the bound interactor scope is active.
    ///
    /// - note: Only the latest value from this publisher is emitted. Values emitted when the interactor is not
    ///   active, are ignored.
    ///
    /// - parameter interactorScope: The interactor scope whose activeness this publisher is confined to.
    /// - returns: The `Publisher` confined to this interactor's activeness lifecycle.
    public func confineTo(_ interactorScope: InteractorScope) -> AnyPublisher<Output, Failure> {
        combineLatest(interactorScope.isActivePublisher).filter { _, isActive in
            isActive
        }.map { value, _ in
            value
        }.eraseToAnyPublisher()
    }
}

/// Interactor related `Cancellable` extensions.
extension Cancellable {
    /// Cancels the subscription based on the lifecycle of the given `Interactor`. The subscription is cancelled
    /// when the interactor is deactivated.
    ///
    /// - note: This is the preferred method when trying to confine a subscription to the lifecycle of an
    ///   `Interactor`.
    ///
    /// When using this composition, the subscription closure may freely retain the interactor itself, since the
    /// subscription closure is cancelled once the interactor is deactivated, thus releasing the retain cycle before
    /// the interactor needs to be deallocated.
    ///
    /// If the given interactor is inactive at the time this method is invoked, the subscription is immediately
    /// terminated.
    ///
    /// - parameter interactor: The interactor to cancel the subscription based on.
    @discardableResult
    public func cancelOnDeactivate(interactor: Interactor) -> Self {
        if interactor.cancellables != nil {
            store(in: &interactor.cancellables!) // swiftlint:disable:this force_unwrapping
        } else {
            cancel()
//            logger.warning("Subscription immediately terminated, since \(String(describing: interactor), privacy: .public) is inactive.")
        }
        return self
    }
}
