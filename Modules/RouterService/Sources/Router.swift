import Factory
import SwiftUI

public protocol RouterProtocol {
    func view(for route: Route) -> AnyView?
    func handle(deepLink url: URL) -> Bool
}

public class Router: RouterProtocol {
    
    private var routeRegistry: [String: () -> AnyView] = [:]
    private var deepLinkRegistry: [String: Route] = [:]
    
    public func view(for route: Route) -> AnyView? {
        return route.getBuilder().buildView(fromRoute: route)
    }
    
    public func handle(deepLink url: URL) -> Bool {
        return false
    }
}

// MARK: - Deeplinking Support

public struct DeepLinkHandler {
    let router: Router
    
    func handle(url: URL) -> Bool {
        return router.handle(deepLink: url)
    }
}
