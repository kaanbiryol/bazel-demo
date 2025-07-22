import Factory
import SwiftUI
import Combine

public protocol RouterProtocol {
    var deepLinkPublisher: PassthroughSubject<any Route, Never> { get }
    
    func view(for route: any Route) -> AnyView
    
    func handle(deepLink url: URL) -> Bool
    func registerDeepLink<R: Route>(pathPrefix: String, factory: @escaping (URL) -> R?)
}

public class Router: RouterProtocol {
    private var deepLinkRegistry: [String: (URL) -> (any Route)?] = [:]
    
    public var deepLinkPublisher = PassthroughSubject<any Route, Never>()
    
    public func view(for route: any Route) -> AnyView {
        return route.getBuilder().buildView()
    }
    
    public func registerDeepLink<R: Route>(pathPrefix: String, factory: @escaping (URL) -> R?) {
        deepLinkRegistry[pathPrefix] = { url in
            factory(url)
        }
    }
    
    public func handle(deepLink url: URL) -> Bool {
        let urlString = url.absoluteString
        for (pathPrefix, factory) in deepLinkRegistry {
            if urlString.contains(pathPrefix) {
                if let route = factory(url) {
                    deepLinkPublisher.send(route)
                    return true
                }
            }
        }
        return false
    }

}
