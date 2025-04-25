import Combine

/// @mockable
protocol RouterTracking {
    var routerTreeDidChangeSubject: CurrentValueSubject<Void, Never>? { get set }
}

/// The lifecycle stages of a router scope.
public enum RouterLifecycle {
    /// Router did load.
    case didLoad
}

/// The scope of a `Router`, defining various lifecycles of a `Router`.
/// @mockable
public protocol RouterScope: AnyObject {
    /// A publisher that emits values when the router scope reaches its corresponding life-cycle stages. This
    /// publisher completes when the router scope is deallocated.
    var lifecycle: AnyPublisher<RouterLifecycle, Never> { get }
}

/// Describes the way the router was attached to it's parent
public enum AttachingType {
    case _none // swiftlint:disable:this identifier_name
    case viewless
    case embedded
    case mapTop
    case mapBottomSheet
    case presented
    case pushed
    case modal
    case tab(isActive: AnyPublisher<Bool, Never>)

    var priority: Int {
        switch self {
        case ._none:
            -1
        case .embedded, .mapTop:
            0
        case .mapBottomSheet:
            1
        /// Used for modals overlaying parts of the screen, such as alerts or action sheets. Should not be used for full screen modals!
        case .modal:
            2
        case .tab:
            3
        case .presented, .viewless:
            4
        case .pushed:
            5
        }
    }

    func hasSameCaseAs(_ another: AttachingType) -> Bool {
        switch (self, another) {
        case (._none, ._none), (.viewless, .viewless), (.embedded, .embedded), (.tab, .tab), (.presented, .presented), (.pushed, .pushed), (.modal, .modal):
            true
        default:
            false
        }
    }
}

public struct ChildNode {
    public let router: Routing
    public let attachingType: AttachingType

    var priority: Int {
        attachingType.priority
    }

    public init(router: Routing, attachingType: AttachingType) {
        self.router = router
        self.attachingType = attachingType
    }
}

/// The base protocol for all routers.
/// @mockable
public protocol Routing: RouterScope {
    // The following methods must be declared in the base protocol, since `Router` internally  invokes these methods.
    // In order to unit test router with a mock child router, the mocked child router first needs to conform to the
    // custom subclass routing protocol, and also this base protocol to allow the `Router` implementation to execute
    // base class logic without error.

    /// A description set to make the node trackable.
    var trackingDescription: String? { get set }

    /// The base interactable associated with this `Router`.
    var interactable: Interactable { get }

    /// The list of children routers of this `Router`.
    var children: [ChildNode] { get }

    /// Loads the `Router`.
    ///
    /// - note: This method is internally used by the framework. Application code should never
    ///   invoke this method explicitly.
    func load()

    // We cannot declare the attach/detach child methods to take in concrete `Router` instances,
    // since during unit testing, we need to use mocked child routers.

    /// Detaches the given router from the tree.
    ///
    /// - parameter child: The child router to detach.
    func detachChild(_ child: Routing)

    /// Attaches the given router as a child with an attaching type.
    ///
    /// - Parameters:
    ///   - child: The child router to attach.
    ///   - attachingType: The attaching type used.
    func attachChild(_ child: Routing, attachingType: AttachingType)

    /// Detaches all router children from the tree.
    func detachAllChildren()
}

/// The base class of all routers that does not own view controllers, representing application states.
///
/// A router acts on inputs from its corresponding interactor, to manipulate application state, forming a tree of
/// routers. A router may obtain a view controller through constructor injection to manipulate view controller tree.
/// The DI structure guarantees that the injected view controller must be from one of this router's ancestors.
/// Router drives the lifecycle of its owned `Interactor`.
///
/// Routers should always use helper builders to instantiate children routers.
open class Router<InteractorType>: Routing, RouterTracking {
    var routerTreeDidChangeSubject: CurrentValueSubject<Void, Never>?

    public var trackingDescription: String?

    /// The corresponding `Interactor` owned by this `Router`.
    public let interactor: InteractorType

    /// The base `Interactable` associated with this `Router`.
    public let interactable: Interactable

    /// The list of children `ChildNode`s of this `Router`.
    public var children: [ChildNode] = []

    /// The publisher that emits values when the router scope reaches its corresponding life-cycle stages.
    ///
    /// This publisher completes when the router scope is deallocated.
    public final var lifecycle: AnyPublisher<RouterLifecycle, Never> {
        AnyPublisher(lifecycleSubject)
    }

    var deinitCancellables = [AnyCancellable]()

    private var lifecycleSubject = PassthroughSubject<RouterLifecycle, Never>()
    private var didLoadFlag: Bool = false

    /// Initializer.
    ///
    /// - parameter interactor: The corresponding `Interactor` of this `Router`.
    public init(interactor: InteractorType) {
        self.interactor = interactor
        guard let interactable = interactor as? Interactable else {
            fatalError("\(interactor) should conform to \(Interactable.self)")
        }
        self.interactable = interactable
    }

    /// Loads the `Router`.
    ///
    /// - note: This method is internally used by the framework. Application code should never invoke this method
    ///   explicitly.
    public final func load() {
        guard !didLoadFlag else {
            return
        }

        didLoadFlag = true
        internalDidLoad()
        didLoad()
    }

    /// Called when the router has finished loading.
    ///
    /// This method is invoked only once. Subclasses should override this method to perform one time setup logic,
    /// such as attaching immutable children. The default implementation does nothing.
    open func didLoad() {
        // No-op
    }

    // We cannot declare the attach/detach child methods to take in concrete `Router` instances,
    // since during unit testing, we need to use mocked child routers.

    public final func attachChild(_ child: Routing, attachingType: AttachingType) {
        assert(!(children.contains { $0.router === child }), "Attempt to attach child: \(child), which is already attached to \(self).")
//        logger.trace("\(String(describing: self), privacy: .public) attaching child \(String(describing: child), privacy: .public)")

        var trackableChild = child as? RouterTracking
        trackableChild?.routerTreeDidChangeSubject = routerTreeDidChangeSubject
        children.append(ChildNode(router: child, attachingType: attachingType))
        routerTreeDidChangeSubject?.send()

        // Activate child first before loading. Router usually attaches immutable children in didLoad.
        // We need to make sure the RIB is activated before letting it attach immutable children.
        child.interactable.activate()
        child.load()
    }

    /// Detaches the given `Router` from the tree.
    ///
    /// - parameter child: The child `Router` to detach.
    public final func detachChild(_ child: Routing) {
//        logger.trace("\(String(describing: self), privacy: .public) detaching child \(String(describing: child), privacy: .public)")
        var trackableChild = child as? RouterTracking
        trackableChild?.routerTreeDidChangeSubject = nil
        child.interactable.deactivate()
        guard let objIndex = children.firstIndex(where: { $0.router as AnyObject === child as AnyObject }) else {
            return
        }
        children.remove(at: objIndex)
        routerTreeDidChangeSubject?.send()
    }

    /// Detaches all router children from the tree.
    public func detachAllChildren() {
        for child in children {
            detachChild(child.router)
        }
    }

    func internalDidLoad() {
        bindSubtreeActiveState()
        lifecycleSubject.send(.didLoad)
    }

    private func bindSubtreeActiveState() {
        interactable.isActivePublisher
            // Do not retain self here to guarantee execution. Retaining self will cause the dispose bag
            // to never be disposed, thus self is never deallocated. Also cannot just store the disposable
            // and call dispose(), since we want to keep the subscription alive until deallocation, in
            // case the router is re-attached. Using weak does require the router to be retained until its
            // interactor is deactivated.
            .sink { [weak self] isActive in
                // When interactor becomes active, we are attached to parent, otherwise we are detached.
                self?.setSubtreeActive(isActive)
            }
            .store(in: &deinitCancellables)
    }

    private func setSubtreeActive(_ active: Bool) {
        if active {
            iterateSubtree(self) { router in
                if !router.interactable.isActive {
                    router.interactable.activate()
                }
            }
        } else {
            iterateSubtree(self) { router in
                if router.interactable.isActive {
                    router.interactable.deactivate()
                }
            }
        }
    }

    private func iterateSubtree(_ root: Routing, closure: (_ node: Routing) -> Void) {
        closure(root)

        for child in root.children {
            iterateSubtree(child.router, closure: closure)
        }
    }

    deinit {
//        logger.trace("\(String(describing: self), privacy: .public) is deinitializing")
        interactable.deactivate()

        if !children.isEmpty {
            detachAllChildren()
        }

        lifecycleSubject.send(completion: .finished)
        deinitCancellables.forEach { $0.cancel() }

        LeakDetector.instance.expectDeallocate(object: interactable)
    }
}
