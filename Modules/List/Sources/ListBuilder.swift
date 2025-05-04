import Foundation
import SwiftUI
import NetworkingInterface
import RouterService
import Factory
import UIKit
import RIBs
import DetailsInterface
import ListInterface
import HomeInterface
import OrderInterface

//struct ListView: View {
//    
//    @State var showDetails = false
//    
//    @State private var path = NavigationPath()
////    NavigationStack(path: $path) {
////        List {
////            NavigationLink("Mint", value: Color.mint)
////            NavigationLink("Red", value: Color.red)
////        }
////        .navigationDestination(for: Color.self) { color in
////            Text("test")
////        }
////    }
//    
//    @State var selection: RentDetailsSelection = RentDetailsSelection(value: "")
//    @Injected(\.router) private var router
//
//    public var body: some View {
//        NavigationStack {
//            VStack {
//                Button("Show details") {
//                    showDetails = true
//                }
//                .routeTo(
//                    route: RentDetailsRoute(selection: $selection),
//                    isActive: $showDetails,
//                    style: .push
//                )
//                Text("Selection: \($selection.value.wrappedValue)")
//            }
//        }
//        
//        EmptyView()
//            .tabRouteTo(tabItems: [
//                TabItem(label: "Menu", systemImage: "list.dash", route: HomeTabRoute()),
//                TabItem(label: "Order", systemImage: "square.and.pencil", route: OrderTabRoute())
//            ])
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

struct RouteTabItem: View {
    let route: Route
    
    init(route: Route) {
        self.route = route
    }
    
    var body: some View {
        if let view = route.getBuilder().buildView(fromRoute: route) {
            view
        } else {
            EmptyView()
        }
    }
}

struct ListView: View {
    public var body: some View {
        TabView {
            RouteTabItem(
                route: HomeRoute()
            )
            
            RouteTabItem(
                route: OrderRoute()
            )
           
        }
    }
}



// TODO: should we consider making this?
//extension Route {
//    func view() -> some View {
//        let builder = getBuilder()
//        if let view = builder.buildView(fromRoute: self) {
//            return view
//        } else {
//            return AnyView(EmptyView())
//        }
//    }
//}
//
//// Make HomeRoute and OrderRoute conform to View
//extension HomeRoute: View {
//    public var body: some View {
//        view()
//    }
//}
//
//extension OrderRoute: View {
//    public var body: some View {
//        view()
//    }
//}
//
