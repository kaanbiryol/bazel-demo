import Foundation
import SwiftUI
import NetworkingInterface
import SummaryInterface
import RouterService
import Factory
import UIKit
import RIBs
import Combine
import OrderInterface
import HomeInterface
import SelectionRIB
import SelectionInterface

struct ListView: View {
    
    @State var showDetails = false
    @State var showSimpleTextRIB = false
    
    @State var navigationPath = NavigationPath()
    
    @State var selection: SummarySelection = SummarySelection(value: "")
    @State var selectionModel: SelectionSelection = SelectionSelection(value: "")
    @Injected(\.router) private var router
    
    @State private var showModal = false
    @State private var currentModalRoute: (any Route)? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    public var body: some View {
        RouteNavigationStack(path: $navigationPath) {
            VStack {
                List(1...50, id: \.self) { item in
                    NavigationLink(route: SelectionRoute(selection: .constant(SelectionSelection(value: "Element \(item)")))) {
                        Text("Element \(item)")
                            .padding(.vertical, 4)
                    }
                }
                .navigationTitle("List")
                
                Button("Go to Order") {
                    navigationPath.push(to: OrderRoute())
                }
                
                Button("Simulate Deep Link to Selection 123") {
                    let url = URL(string: "myapp://selection/123")! // Example URL
                    _ = router.handle(deepLink: url)
                }
            }
        }
        .routeTo(route: currentModalRoute ?? SelectionRoute(selection: .constant(SelectionSelection(value: "Fallback"))), isActive: $showModal, style: .sheet) // Use .routeTo instead
        .onReceive(router.deepLinkPublisher) { route in
            currentModalRoute = route
            showModal = true
        }
        .onOpenURL { url in
            _ = router.handle(deepLink: url)
        }
        .onAppear {
            router.registerDeepLink<SelectionRoute>(pathPrefix: "selection") { url in
                
                let urlString = url.absoluteString
                print("📱 Processing selection URL: \(urlString)")
                if let id = urlString.split(separator: "/").last {
                    print("🆔 Extracted ID: \(id)")
                    return SelectionRoute(selection: .constant(SelectionSelection(value: "Deep Link ID: \(id)")))
                }
                return nil
            }
        }
        
        // TODO: This is also possible
        //        NavigationStack(path: $navigationPath) {
        //            List(1...50, id: \.self) { item in
        //                NavigationLink(
        //                    route: SelectionRoute(selection: .constant(SelectionSelection(value: "Element \(item)"))),
        //                    navigationPath: $navigationPath
        //                ) {
        //                    Text("Element \(item)")
        //                        .padding(.vertical, 4)
        //                }
        //
        //                NavigationLink(
        //                    route: OrderRoute(),
        //                    navigationPath: $navigationPath
        //                ) {
        //                    Text("Order \(item)")
        //                        .padding(.vertical, 4)
        //                }
        //            }
        //            .navigationTitle("List")
        //        }
        //
        
        //        NavigationStack {
        //            //            Button("Show details") {
        //            //                showDetails = true
        //            //            }
        //            //            .routeTo(
        //            //                route: RentDetailsRoute(selection: $selection),
        //            //                isActive: $showDetails,
        //            //                style: .push
        //            //            )
        //            List(Array(1...50), id: \.self) { item in
        //                Button("Element \(item)") {
        //                    //nav path?
        //                    showSimpleTextRIB = true
        //                }
        //                .padding(.vertical, 4)
        //            }
        //            .navigationDestination(isPresented: $showSimpleTextRIB, destination: {
        //                SelectionRIBRepresentable()
        //            })
        //            .navigationTitle("List")
        //
        //            VStack(spacing: 20) {
        //                Button("Show details") {
        //                    showDetails = true
        //                }
        //                .routeTo(
        //                    route: RentDetailsRoute(selection: $selection),
        //                    isActive: $showDetails,
        //                    style: .push
        //                )
        //
        //                Button("Show SimpleTextRIB") {
        //                    showSimpleTextRIB = true
        //                }
        //                .navigationDestination(isPresented: $showSimpleTextRIB, destination: {
        //                    SimpleTextRIBView()
        //                })
        //
        //                Text("Selection: \($selection.value.wrappedValue)")
        //            }
        //        }
        
        //        EmptyView()
        //            .tabRouteTo(tabItems: [
        //                TabItem(label: "Menu", systemImage: "list.dash", route: HomeTabRoute()),
        //                TabItem(label: "Order", systemImage: "square.and.pencil", route: OrderTabRoute())
        //            ])
    }
}


struct RouteTabItem: View {
    let route: any Route
    
    init(route: any Route) {
        self.route = route
    }
    
    var body: some View {
        route.getBuilder().buildView(fromRoute: route)
    }
}

//struct ListView: View {
//    public var body: some View {
//        TabView {
//            RouteTabItem(
//                route: HomeRoute()
//            )
//
//            RouteTabItem(
//                route: OrderRoute()
//            )
//
//        }
//    }
//}


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

// Mock for preview
public class Mock: NetworkingService {
    public init() {}
    
    public func fetchTitle() -> String {
        return "List Items"
    }
    
    public func fetchDetails() -> String {
        return "Details"
    }
}
