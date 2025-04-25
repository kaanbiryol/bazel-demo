import SwiftUI
import RouterService
import NetworkingInterface
import UIKit
import DetailsInterface

public struct DetailsFeature: Feature {
    @Dependency var networkingService: NetworkingService
    
    private let element: Int
    
    public init(element: Int) {
        self.element = element
    }
    
    public init() {
        self.element = 0
    }
    
    public var dependencies: [Any.Type] {
        [NetworkingService.self]
    }
    
    // UIKit implementation - required by Feature protocol
    public func build(fromRoute route: Route?) -> UIViewController {
//        if let detailsRoute = route as? DetailsRoute {
//            let view = DetailsView(element: detailsRoute.element)
//            return UIHostingController(rootView: view)
//        }
//        
//        let view = DetailsView(element: element)
//        return UIHostingController(rootView: view)
        return UIViewController()
    }
    
    // SwiftUI implementation
    public func buildSwiftUIView(fromRoute route: Route?) -> AnyView? {
        if let detailsRoute = route as? DetailsRoute {
            return AnyView(DetailsView(element: detailsRoute.element))
        }
        
        return AnyView(DetailsView(element: element))
    }
    
    public func isEnabled() -> Bool {
        return true
    }
    
    public func fallback(forRoute route: Route?) -> Feature.Type? {
        return nil
    }
} 
