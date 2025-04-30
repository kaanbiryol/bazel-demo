import Factory
import SwiftUI

public protocol RouterProtocol {
    func view(for route: Route) -> AnyView?
    func navigate(to route: Route, style: NavigationStyle)
    func handle(deepLink url: URL) -> Bool
    func register<V: View>(route: Route.Type, view: @escaping () -> V)
}

public class Router: RouterProtocol, ObservableObject {
    @Published var activeRoute: Route?
    @Published var navigationStyle: NavigationStyle = .push
    @Published var isPresenting: Bool = false
    
    private var routeRegistry: [String: () -> AnyView] = [:]
    private var deepLinkRegistry: [String: Route] = [:]
    
    public func register<V: View>(route: Route.Type, view: @escaping () -> V) {
        // No-op for backward compatibility
    }
    
    public func view(for route: Route) -> AnyView? {
        return route.getBuilder().buildView(fromRoute: route)
    }
    
    public func navigate(to route: Route, style: NavigationStyle) {
        self.activeRoute = route
        self.navigationStyle = style
        self.isPresenting = true
    }
    
    public func handle(deepLink url: URL) -> Bool {
        // This would need to be refactored based on your deep linking needs
        return false
    }
}


public struct EmptyRoute: Route {
    public static var identifier: String { "empty" }
    
    public func getBuilder() -> Builder2 {
        fatalError()
    }
}

// MARK: - Deeplinking Support

public struct DeepLinkHandler {
    let router: Router
    
    func handle(url: URL) -> Bool {
        return router.handle(deepLink: url)
    }
}
