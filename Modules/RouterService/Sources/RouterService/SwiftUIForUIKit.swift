import SwiftUI
import UIKit

/// A SwiftUI View that renders a feature using RouterService
public struct FeatureView: View {
    private let routerService: RouterServiceProtocol
    private let featureType: Feature.Type
    private let route: Route?
    
    public init(
        routerService: RouterServiceProtocol,
        feature: Feature.Type,
        route: Route? = nil
    ) {
        self.routerService = routerService
        self.featureType = feature
        self.route = route
    }
    
    public var body: some View {
//        return routerService.swiftUIView(forFeature: featureType, route: route)
        return routerService.view(forRoute: route!)
        
//        let instance = featureType.initialize(withStore: (routerService as? RouterService)?.store)
//        let viewController = instance.build(fromRoute: route)
//        UIViewControllerRepresentable(viewController)
        
    }
} 
