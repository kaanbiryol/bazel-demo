/// The base builder protocol that all builders should conform to.
/// @mockable
public protocol Buildable: AnyObject {}

/// Utility that instantiates a RIB and sets up its internal wirings.
open class Builder<Component, DynamicDependency>: Buildable {
    // Builder should not directly retain an instance of the component.
    // That would make the component's lifecycle longer than the built
    // RIB. Instead, whenever a new instance of the RIB is built, a new
    // instance of the DI component should also be instantiated.

    // Cannot store the component builder closure in the base class. Swift
    // compiler has a bug where if the closure is stored here, the return
    // value from invoking the closure will be some random object in memory.
    // Some times it's a valid object. Other times it's a bad address

    private let internalComponentBuilder: (DynamicDependency) -> Component

    /// Initializer.
    ///
    /// - parameter componentBuilder: The closure to instantiate a new
    /// instance of the DI component that should be paired with this RIB.
    public init(componentBuilder: @escaping (DynamicDependency) -> Component) {
        internalComponentBuilder = componentBuilder
    }

    /// Instantiate a new instance of the DI component
    /// that should be paired with this RIB.
    /// - parameter dynamicDependency: The dynamic dependency required to instantiate a new component.
    /// - returns: A new instance of the component that should be paired with this RIB.
    public func componentBuilder(_ dynamicDependency: DynamicDependency) -> Component {
        internalComponentBuilder(dynamicDependency)
    }
}

extension Builder where DynamicDependency == Void {
    /// Instantiate a new instance of the DI component
    /// that should be paired with this RIB.
    /// - returns: A new instance of the component that should be paired with this RIB.
    public func componentBuilder() -> Component {
        componentBuilder(())
    }
}
