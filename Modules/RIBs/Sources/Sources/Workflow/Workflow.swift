import Combine

/// Defines the base class for a sequence of steps that execute a flow through the application RIB tree.
///
/// At each step of a `Workflow` is a pair of value and actionable item. The value can be used to make logic decisions.
/// The actionable item is invoked to perform logic for the step. Typically the actionable item is the `Interactor` of a
/// RIB.
///
/// A workflow should always start at the root of the tree.
open class Workflow<ActionableItemType> {
    /// Called when the last step publisher is completed.
    ///
    /// Subclasses should override this method if they want to execute logic at this point in the `Workflow` lifecycle.
    /// The default implementation does nothing.
    open func didComplete() {
        // No-op
    }

    /// Called when the `Workflow` is forked.
    ///
    /// Subclasses should override this method if they want to execute logic at this point in the `Workflow` lifecycle.
    /// The default implementation does nothing.
    open func didFork() {
        // No-op
    }

    /// Called when the last step publisher is has error.
    ///
    /// Subclasses should override this method if they want to execute logic at this point in the `Workflow` lifecycle.
    /// The default implementation does nothing.
    open func didReceiveError(_: Error) {
        // No-op
    }

    private let subject = PassthroughSubject<(ActionableItemType, ()), Error>()
    private var didInvokeComplete = false
    public var completion: (() -> Void)?

    /// Initializer.
    public init() {}

    /// Execute the given closure as the root step.
    ///
    /// - parameter onStep: The closure to execute for the root step.
    /// - returns: The next step.
    // swiftlint:disable:next generic_type_name
    public final func onStep<NextActionableItemType, NextValueType>(_ onStep: @escaping (ActionableItemType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error>) -> Step<ActionableItemType, NextActionableItemType, NextValueType> {
        Step(workflow: self, publisher: subject.first().eraseToAnyPublisher())
            .onStep { (actionableItem: ActionableItemType, _) in
                onStep(actionableItem)
            }
    }

    /// Subscribe and start the `Workflow` sequence.
    ///
    /// - parameter actionableItem: The initial actionable item for the first step.
    /// - returns: The disposable of this workflow.
    public final func subscribe(_ actionableItem: ActionableItemType) -> AnyCancellable {
        guard !compositeDisposable.isEmpty else {
            assertionFailure("Attempt to subscribe to \(self) before it is comitted.")
            return AnyCancellable {}
        }

        subject.send((actionableItem, ()))
        return AnyCancellable {
            self.compositeDisposable.removeAll()
        }
    }

    /// The composite disposable that contains all subscriptions including the original workflow
    /// as well as all the forked ones.
    fileprivate var compositeDisposable = [AnyCancellable]()

    fileprivate func didCompleteIfNotYet() {
        // Since a workflow may be forked to produce multiple subscribed Rx chains, we should
        // ensure the didComplete method is only invoked once per Workflow instance. See `Step.commit`
        // on why the side-effects must be added at the end of the Rx chains.
        guard !didInvokeComplete else {
            return
        }
        didInvokeComplete = true
        didComplete()
        completion?()
    }
}

/// Defines a single step in a `Workflow`.
///
/// A step may produce a next step with a new value and actionable item, eventually forming a sequence of `Workflow`
/// steps.
///
/// Steps are asynchronous by nature.
// swiftlint:disable:next generic_type_name
open class Step<WorkflowActionableItemType, ActionableItemType, ValueType> {
    private let workflow: Workflow<WorkflowActionableItemType>
    private var publisher: AnyPublisher<(ActionableItemType, ValueType), Error>

    fileprivate init(workflow: Workflow<WorkflowActionableItemType>, publisher: AnyPublisher<(ActionableItemType, ValueType), Error>) {
        self.workflow = workflow
        self.publisher = publisher
    }

    /// Executes the given closure for this step.
    ///
    /// - parameter onStep: The closure to execute for the `Step`.
    /// - returns: The next step.
    // swiftlint:disable:next generic_type_name
    public final func onStep<NextActionableItemType, NextValueType>(_ onStep: @escaping (ActionableItemType, ValueType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error>) -> Step<WorkflowActionableItemType, NextActionableItemType, NextValueType> {
        let confinedNextStep = publisher
            .map { actionableItem, value -> AnyPublisher<(Bool, ActionableItemType, ValueType), Error> in
                // We cannot use generic constraint here since Swift requires constraints be
                // satisfied by concrete types, preventing using protocol as actionable type.
                if let interactor = actionableItem as? Interactable {
                    interactor
                        .isActivePublisher
                        .map { isActive in
                            (isActive, actionableItem, value)
                        }
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    Just((true, actionableItem, value)).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
            }

            .switchToLatest()
            .first { (isActive: Bool, _, _) -> Bool in
                isActive
            }
            .map { (_, actionableItem: ActionableItemType, value: ValueType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error> in
                onStep(actionableItem, value)
            }
            .switchToLatest()
            .first()
            .share()
            .eraseToAnyPublisher()

        return Step<WorkflowActionableItemType, NextActionableItemType, NextValueType>(workflow: workflow, publisher: confinedNextStep)
    }

    /// Executes the given closure when the `Step` produces an error.
    ///
    /// - parameter onError: The closure to execute when an error occurs.
    /// - returns: This step.
    public final func onError(_ onError: @escaping ((Error) -> Void)) -> Step<WorkflowActionableItemType, ActionableItemType, ValueType> {
        publisher = publisher
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    onError(error)
                }
            })
            .eraseToAnyPublisher()
        return self
    }

    /// Commit the steps of the `Workflow` sequence.
    ///
    /// - returns: The committed `Workflow`.
    @discardableResult
    public final func commit() -> Workflow<WorkflowActionableItemType> {
        // Side-effects must be chained at the last publisher sequence, since errors and complete
        // events can be emitted by any publisher on any steps of the workflow.
        let disposable = publisher
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.workflow.didCompleteIfNotYet()
                case let .failure(error):
                    self.workflow.didReceiveError(error)
                }
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })

        disposable.store(in: &workflow.compositeDisposable)
        return workflow
    }

    /// Convert the `Workflow` into an publisher.
    ///
    /// - returns: The publisher representation of this `Workflow`.
    public final func asAnyPublisher() -> AnyPublisher<(ActionableItemType, ValueType), Error> {
        publisher
    }
}

/// `Workflow` related publisher extensions.
extension Publisher {
    /// Fork the step from this publisher.
    ///
    /// - parameter workflow: The workflow this step belongs to.
    /// - returns: The newly forked step in the workflow. `nil` if this publisher does not conform to the required
    ///   generic type of (ActionableItemType, ValueType).
    // swiftlint:disable:next generic_type_name
    public func fork<WorkflowActionableItemType, ActionableItemType, ValueType>(_ workflow: Workflow<WorkflowActionableItemType>) -> Step<WorkflowActionableItemType, ActionableItemType, ValueType>? {
        if let stepPublisher = self as? AnyPublisher<(ActionableItemType, ValueType), Error> {
            workflow.didFork()
            return Step(workflow: workflow, publisher: stepPublisher)
        }
        return nil
    }
}

/// `Workflow` related `Cancellable` extensions.
extension Cancellable {
    /// Cancel the subscription when the given `Workflow` is cancelled.
    ///
    /// When using this composition, the subscription closure may freely retain the workflow itself, since the
    /// subscription closure is cancelled once the workflow is cancelled, thus releasing the retain cycle before the
    /// `Workflow` needs to be deallocated.
    ///
    /// - note: This is the preferred method when trying to confine a subscription to the lifecycle of a `Workflow`.
    ///
    /// - parameter workflow: The workflow to cancel the subscription with.
    public func cancelWith(worflow: Workflow<some Any>) {
        store(in: &worflow.compositeDisposable)
    }
}
