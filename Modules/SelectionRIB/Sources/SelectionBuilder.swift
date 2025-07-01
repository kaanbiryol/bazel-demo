import RIBs

// MARK: - BuilderProtocol
public protocol SelectionBuildable: Buildable {
    func build() -> SelectionRouting
}

// MARK: - Builder
public final class SelectionBuilder: SelectionBuildable {
    public init() {}
    
    public func build() -> SelectionRouting {
        let viewController = SelectionViewController()
        let interactor = SelectionTextInteractor(presenter: viewController)
        let router = SelectionRouter(interactor: interactor, viewController: viewController)
        return router
    }
}
