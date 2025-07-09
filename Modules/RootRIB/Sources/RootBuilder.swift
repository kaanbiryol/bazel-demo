import RIBs
import UIKit

// MARK: - RootBuilder
public protocol RootRIBBuildable: Buildable {
    func build() -> RootRouting
}

public final class RootRIBBuilder: RootRIBBuildable {
    public init() {}
    
    public func build() -> RootRouting {
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)
        let router = RootRouter(interactor: interactor, viewController: viewController)
        return router
    }
} 