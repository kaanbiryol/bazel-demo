import Foundation
import UIKit
import SwiftUI

public protocol RouterServiceProtocol {
    func navigate(
        toRoute route: Route,
        fromView viewController: UIViewController,
        presentationStyle: PresentationStyle,
        animated: Bool,
        completion: (() -> Void)?
    )
    
    /// SwiftUI support - Creates a view for a given route
    func view(forRoute route: Route) -> AnyView?
    
    /// SwiftUI support - Creates a SwiftUI navigation controller with initial feature
    func hostingController<T: View>(withRootView view: T) -> UIViewController
}

public extension RouterServiceProtocol {
    func navigate(
        toRoute route: Route,
        fromView viewController: UIViewController,
        presentationStyle: PresentationStyle,
        animated: Bool
    ) {
        navigate(
            toRoute: route,
            fromView: viewController,
            presentationStyle: presentationStyle,
            animated: animated,
            completion: nil
        )
    }
}

public typealias DependencyFactory = () -> AnyObject

public protocol RouterServiceRegistrationProtocol {
    func register<T>(dependencyFactory: @escaping DependencyFactory, forType metaType: T.Type)
    func register(routeHandler: RouteHandler)
}

public protocol RouterServiceScopeProtocol {
    func register(scope: String)
    func enter(scope: String)
    func leave(scope: String)
}
