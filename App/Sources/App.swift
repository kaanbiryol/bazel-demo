//
//  AppApp.swift
//  App
//
//  Created by Kaan Biryol on 01.11.23.
//

import SwiftUI
import Collections
import NetworkingInterface
import ListInterface
import List
import DetailsInterface
import Details
import RouterService
import Networking
import Factory

extension Container {
    var routerService: Factory<RouterService> {
        self { RouterService() }
    }
    var networkingService: Factory<NetworkingService> {
        self { NetworkingImpl() }
    }
}

@main
struct AppApp: App {
//    @Injected(\Container.networkingService) private var networkingService
//    @Injected(\Container.routerService) private var routerService
    
    let routerService: RouterService = RouterService()
    
    init() {
        // Initialize Router and Register Dependencies
//        let store = Store()
//        self.routerService = RouterService(store: store)
        
        routerService.register(dependencyFactory: {
              return NetworkingImpl()
          }, forType: NetworkingService.self)
        
        routerService.register(routeHandler: DetailsRouteHandler())
        
        // Register services/dependencies
//        store.register({ NetworkingImpl() }, forMetaType: NetworkingService.self)
//        store.register({ routerService }, forMetaType: RouterService.self)
        
        // Register route handlers
//        let detailsRouteHandler = DetailsRouteHandler()
//        detailsRouteHandler.registerRoutes(with: routerService)
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView(routerService: routerService)
        }
    }
}

// Root view that displays the ListView feature
struct AppRootView: View {
    
    private var routerService: RouterService
    
    public init(routerService: RouterService) {
        self.routerService = routerService
    }
    
    var body: some View {
        if let listView = routerService.swiftUIView(forFeature: ListFeature.self) {
            listView
                .navigationViewStyle(StackNavigationViewStyle())
        } else {
        
        }
    }
}

private class CollectionsTest {
    func deque() {
        var deque: Deque<String> = ["Ted", "Rebecca"]
        deque.prepend("Keeley")
        deque.append("Nathan")
        print(deque) // ["Keeley", "Ted", "Rebecca", "Nathan"]
    }
}
