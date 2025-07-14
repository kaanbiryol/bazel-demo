import Factory
import SwiftUI
import Combine

public protocol RouterProtocol {
    func view(for route: any Route) -> AnyView
    func handle(deepLink url: URL) -> Bool
}

public class Router: RouterProtocol {
    
    private var routeRegistry: [String: () -> AnyView] = [:]
    private var deepLinkRegistry: [String: (URL) -> (any Route)?] = [:] // Path prefix to route factory
    public private(set) var deepLinkPublisher = PassthroughSubject<any Route, Never>() // To notify of deep links
    
    public func view(for route: any Route) -> AnyView {
        return route.getBuilder().buildView()
    }
    
    public func registerDeepLink<R: Route>(pathPrefix: String, factory: @escaping (URL) -> R?) {
        deepLinkRegistry[pathPrefix] = { url in
            factory(url) as? (any Route)
        }
    }
    
    public func handle(deepLink url: URL) -> Bool {
        let urlString = url.absoluteString
        print("🔗 Handling deep link: \(urlString)")
        
        for (pathPrefix, factory) in deepLinkRegistry {
            if urlString.contains(pathPrefix) {
                print("✅ Matched prefix: \(pathPrefix)")
                if let route = factory(url) {
                    deepLinkPublisher.send(route)
                    return true
                }
            }
        }
        
        print("❌ No matching prefix found")
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
