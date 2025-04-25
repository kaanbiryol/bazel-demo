import Foundation
import UIKit
import SwiftUI

public final class RouterService: RouterServiceProtocol, RouterServiceRegistrationProtocol {

    let store: StoreInterface
    let failureHandler: () -> Void

    private(set) var registeredRoutes = [String: (Route.Type, RouteHandler)]()

    public init(
        store: StoreInterface? = nil,
        failureHandler: @escaping () -> Void = { preconditionFailure() }
    ) {
        self.store = store ?? Store()
        self.failureHandler = failureHandler
        register(dependencyFactory: { [unowned self] in
            self
        }, forType: RouterServiceProtocol.self)
    }

    public func register<T>(
        dependencyFactory: @escaping DependencyFactory,
        forType metaType: T.Type
    ) {
        store.register(dependencyFactory, forMetaType: metaType)
    }

    public func register(routeHandler: RouteHandler) {
        routeHandler.routes.forEach {
            registeredRoutes[$0.identifier] = ($0, routeHandler)
        }
    }

    public func navigationController(
        withInitialFeature feature: Feature.Type
    ) -> UINavigationController {
        let instance = feature.initialize(withStore: store)
        let rootViewController = instance.build(fromRoute: nil)
        return UINavigationController(rootViewController: rootViewController)
    }
    
    // MARK: - SwiftUI Support
    
    /// Creates a hosting controller for a SwiftUI view
    public func hostingController<T: View>(withRootView view: T) -> UIViewController {
        return UIHostingController(rootView: view)
    }
    
    /// Creates a hosting controller for a SwiftUI view with a navigation controller wrapper
    public func navigationController<T: View>(withRootView view: T) -> UINavigationController {
        let hostingController = UIHostingController(rootView: view)
        return UINavigationController(rootViewController: hostingController)
    }
    
    /// Creates a SwiftUI view for a feature
    public func swiftUIView(forFeature feature: Feature.Type, route: Route? = nil) -> AnyView? {
        let instance = feature.initialize(withStore: store)
        return instance.buildSwiftUIView(fromRoute: route)
    }
    
    /// Creates a SwiftUI view for a route
    public func view(forRoute route: Route) -> AnyView? {
        guard let handler = handler(forRoute: route) else {
            return nil
        }
        
        let destinationFeatureType = handler.destination(forRoute: route, fromViewController: nil)
        let destinationFeature = destinationFeatureType.initialize(withStore: store)
        
        if destinationFeature.isEnabled() {
            return destinationFeature.buildSwiftUIView(fromRoute: route)
        }
//        else if let fallbackFeatureType = destinationFeature.fallback(forRoute: route),
//                  let fallbackDestinationFeature = fallbackFeatureType.initialize(withStore: store) {
//            return fallbackDestinationFeature.buildSwiftUIView(fromRoute: route)
//        }
        
        return nil
    }

    public func navigate(
        toRoute route: Route,
        fromView viewController: UIViewController,
        presentationStyle: PresentationStyle,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        guard let handler = handler(forRoute: route) else {
            failureHandler()
            return
        }
        let destinationFeatureType = handler.destination(
            forRoute: route,
            fromViewController: viewController
        )
        let destinationFeature = destinationFeatureType.initialize(withStore: store)
        let destinationViewController: UIViewController
        
        if destinationFeature.isEnabled() {
            destinationViewController = destinationFeature.build(fromRoute: route)
        } else {
            let fallbackFeatureType = destinationFeature.fallback(forRoute: route)
            guard let fallbackDestinationFeature = fallbackFeatureType?.initialize(withStore: store) else {
                failureHandler()
                return
            }
            
            destinationViewController = fallbackDestinationFeature.build(fromRoute: route)
        }
        
        presentationStyle.present(
            viewController: destinationViewController,
            fromViewController: viewController,
            animated: animated,
            completion: completion
        )
    }

    func handler(forRoute route: Route) -> RouteHandler? {
        let routeIdentifier = type(of: route).identifier
        return registeredRoutes[routeIdentifier]?.1
    }
}
