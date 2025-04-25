import Combine

/// The base protocol of all workers that perform a self-contained piece of logic.
///
/// `Worker`s are always bound to an `Interactor`. A `Worker` can only start if its bound `Interactor` is active.
/// It is stopped when its bound interactor is deactivated.
/// @mockable
public protocol Working: AnyObject {
    /// Starts the `Worker`.
    ///
    /// If the bound `InteractorScope` is active, this method starts the `Worker` immediately. Otherwise the `Worker`
    /// will start when its bound `Interactor` scope becomes active.
    ///
    /// - parameter interactorScope: The interactor scope this worker is bound to.
    func start(_ interactorScope: InteractorScope)

    /// Stops the worker.
    ///
    /// Unlike `start`, this method always stops the worker immediately.
    func stop()

    /// Indicates if the worker is currently started.
    var isStarted: Bool { get }

    /// The lifecycle of this worker.
    ///
    /// Subscription to this publisher always immediately returns the last event. This publisher completes after the
    /// `Worker` is deallocated.
    var isStartedPublisher: AnyPublisher<Bool, Never> { get }
}

/// The base `Worker` implementation.
open class Worker: Working {
    /// Indicates if the `Worker` is started.
    public final var isStarted: Bool {
        isStartedSubject.value
    }

    /// The lifecycle stream of this `Worker`.
    public final var isStartedPublisher: AnyPublisher<Bool, Never> {
        isStartedSubject.eraseToAnyPublisher()
    }

    private let isStartedSubject = CurrentValueSubject<Bool, Never>(false)
    private var interactorBindingCancellable: AnyCancellable?
    fileprivate var cancellables: [AnyCancellable]?

    /// Initializer.
    public init() {
        // No-op
    }

    /// Starts the `Worker`.
    ///
    /// If the bound `InteractorScope` is active, this method starts the `Worker` immediately. Otherwise the `Worker`
    /// will start when its bound `Interactor` scope becomes active.
    ///
    /// - parameter interactorScope: The interactor scope this worker is bound to.
    public final func start(_ interactorScope: InteractorScope) {
        guard !isStarted else {
            return
        }

        stop()

        // Create a separate scope struct to avoid passing the given scope instance, since usually
        // the given instance is the interactor itself. If the interactor holds onto the worker without
        // de-referencing it when it becomes inactive, there will be a retain cycle.
        let weakInteractorScope = WeakInteractorScope(sourceScope: interactorScope)
        bind(to: weakInteractorScope)
    }

    /// Called when the the worker has started.
    ///
    /// Subclasses should override this method and implment any logic that they would want to execute when the `Worker`
    /// starts. The default implementation does nothing.
    ///
    /// - parameter interactorScope: The interactor scope this `Worker` is bound to.
    open func didStart(_: InteractorScope) {}

    /// Stops the worker.
    ///
    /// Unlike `start`, this method always stops the worker immediately.
    public final func stop() {
        guard isStarted else {
            return
        }

        isStartedSubject.value = false
        executeStop()
    }

    /// Called when the worker has stopped.
    ///
    /// Subclasses should override this method and implement any cleanup logic that they might want to execute when
    /// the `Worker` stops. The default implementation does noting.
    ///
    /// - note: All subscriptions added to the disposable provided in the `didStart` method are automatically disposed
    /// when the worker stops.
    open func didStop() {
        // No-op
    }

    private func bind(to interactorScope: InteractorScope) {
        unbindInteractor()

        interactorBindingCancellable = interactorScope.isActivePublisher
            .sink { [weak self] isInteractorActive in
                // Make sure the state of the interactor is different
                // then the state of the worker
                guard isInteractorActive != self?.isStarted else { return }

                if isInteractorActive {
                    self?.isStartedSubject.value = true
                    self?.executeStart(interactorScope)
                } else {
                    self?.isStartedSubject.value = false
                    self?.executeStop()
                }
            }
    }

    private func executeStart(_ interactorScope: InteractorScope) {
        cancellables = [AnyCancellable]()
        didStart(interactorScope)
    }

    private func executeStop() {
        guard cancellables != nil else {
            return
        }

        cancellables?.removeAll()
        cancellables = nil

        didStop()
    }

    private func unbindInteractor() {
        interactorBindingCancellable?.cancel()
        interactorBindingCancellable = nil
    }

    deinit {
        stop()
        unbindInteractor()
        isStartedSubject.send(completion: .finished)
    }
}

/// Worker related `Cancellable` extensions.
extension Cancellable {
    /// Cancels the subscription based on the lifecycle of the given `Worker`. The subscription is cancelled when the
    /// `Worker` is stopped.
    ///
    /// If the given worker is stopped at the time this method is invoked, the subscription is immediately completed.
    ///
    /// - note: When using this composition, the subscription closure may freely retain the `Worker` itself, since the
    ///   subscription closure is cancelled once the `Worker` is stopped, thus releasing the retain cycle before the
    ///   `worker` needs to be deallocated.
    ///
    /// - parameter worker: The `Worker` to cancel the subscription based on.
    @discardableResult
    public func cancelOnStop(_ worker: Worker) -> Self {
        if worker.cancellables != nil {
            store(in: &worker.cancellables!) // swiftlint:disable:this force_unwrapping
        } else {
            cancel()
//            logger.warning("Subscription immediately terminated, since \(String(describing: worker), privacy: .public) is stopped.")
        }
        return self
    }
}

private class WeakInteractorScope: InteractorScope {
    weak var sourceScope: InteractorScope?

    var isActive: Bool {
        sourceScope?.isActive ?? false
    }

    var isActivePublisher: AnyPublisher<Bool, Never> {
        sourceScope?.isActivePublisher ?? Just<Bool>(false).eraseToAnyPublisher()
    }

    fileprivate init(sourceScope: InteractorScope) {
        self.sourceScope = sourceScope
    }
}
