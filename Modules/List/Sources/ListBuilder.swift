import Foundation
import SwiftUI
import NetworkingInterface
import RouterService
import Factory
import UIKit
import RIBs
import DetailsInterface
import ListInterface

//public struct ListBuilder: Feature {
//    @Dependency var networkingService: NetworkingService
//    @Dependency var routerService: RouterServiceProtocol
//    
//    public init() {}
//    
//    // UIKit implementation - required by Feature protocol
//    public func build(fromRoute route: Route?) -> UIViewController {
//        let interactor = ListInteractor(networkingService: networkingService, routerService: routerService)
//        let listView = ListView(networkingService: networkingService, routerService: routerService, interactor: interactor)
//        return UIHostingController(rootView: listView)
//    }
//    
//    // SwiftUI implementation
//    public func buildSwiftUIView(fromRoute route: Route?) -> AnyView? {
//        let interactor = ListInteractor(networkingService: networkingService, routerService: routerService)
//        return AnyView(
//            ListView(networkingService: networkingService, routerService: routerService, interactor: interactor)
//        )
//    }
//    
//    public func buildSwiftUIView(fromRoute route: (any Route)?) -> (AnyView?, any Routing) {
//        let interactor = ListInteractor(networkingService: networkingService, routerService: routerService)
//        interactor.activate()
//        let router = ListRouter(interactor: interactor, routerService: routerService)
//        return (
//            AnyView(ListView(networkingService: networkingService, routerService: routerService, interactor: interactor)),
//            router
//        )
//    }
//}

public class ListBuilder: ListBuildable {
    @Injected(\.networkingService) private var networkingService
    @Injected(\.router) private var router
    
    public init() {}
    
    public func buildView(fromRoute route: Route?) -> AnyView? {
        return AnyView(
            ListView()
        )
    }
}

struct ListView: View {
    
    @State var showDetails = false
    
    @State private var path = NavigationPath()
//    NavigationStack(path: $path) {
//        List {
//            NavigationLink("Mint", value: Color.mint)
//            NavigationLink("Red", value: Color.red)
//        }
//        .navigationDestination(for: Color.self) { color in
//            Text("test")
//        }
//    }
    
    @State var selection: RentDetailsSelection = RentDetailsSelection(value: "")
    @Injected(\.router) private var router

    public var body: some View {
        NavigationStack {
            VStack {
                Button("Show details") {
                    showDetails = true
                }
                .routeTo(
                    route: RentDetailsRoute(selection: $selection),
                    isActive: $showDetails,
                    style: .push
                )
                Text("Selection: \($selection.value.wrappedValue)")
            }
        }
        
        EmptyView()
            .tabRouteTo(tabItems: [
                TabItem(label: "Menu", systemImage: "list.dash", route: HomeTabRoute()),
                TabItem(label: "Order", systemImage: "square.and.pencil", route: OrderTabRoute())
            ])
    }
}

// Example route implementations for the tabs
struct HomeTabRoute: Route {
    public static var identifier: String { "home_tab" }
    
    public func getBuilder() -> Builder2 {
        HomeTabBuilder()
    }
}

struct OrderTabRoute: Route {
    public static var identifier: String { "order_tab" }
    
    public func getBuilder() -> Builder2 {
        OrderTabBuilder()
    }
}

class HomeTabBuilder: Builder2 {
    public func buildView(fromRoute route: Route?) -> AnyView? {
        return AnyView(Text("Home Tab"))
    }
}

class OrderTabBuilder: Builder2 {
    public func buildView(fromRoute route: Route?) -> AnyView? {
        return AnyView(Text("Order Tab"))
    }
}

