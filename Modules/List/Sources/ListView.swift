import Foundation
import SwiftUI
import NetworkingInterface
import DetailsInterface
import RouterService
import Factory
import UIKit
import RIBs
import Combine
import OrderInterface
import HomeInterface

import ExampleRIB

//protocol ListInteractable: Interactable {
//    var router: ListRouting? { get set }
//}
//
//protocol ListViewControllable: ViewControllable {
//    func embedQuickFilter(_ viewController: ViewControllable)
//    func unembedQuickFilter(_ viewController: ViewControllable)
//}
//
//protocol ListRouting: Routing {
//    func routeToRentHomeBottomSheet(binding: Binding<Bool>)
//    func cleanupViews()
//    func cleanupPresentedChild()
//}

//final class ListRouter: Router<ListInteractable>, ListRouting {
//    
//    let routerService: RouterServiceProtocol
//    
//    init(interactor: ListInteractable, routerService: RouterServiceProtocol) {
//        self.routerService = routerService
//        super.init(interactor: interactor)
//        interactor.router = self
//    }
//    
//    func routeToRentHomeBottomSheet(binding: Binding<Bool>) {
//        // get builder
////        routerService.navigateTo(route: DetailsRoute(element: 0), isActive: binding, style: .fullScreenCover)
////        attachChild(alert, attachingType: .modal)
//        
//////        viewController.presentViewController(alert.viewControllable)
////
////        currentPresentedChild = alert
//    }
//    
//    func cleanupViews() {
//        
//    }
//    
//    func cleanupPresentedChild() {
//        
//    }
//}
//
//@Observable public class ListInteractor: Interactor, ListInteractable {
//    @ObservationIgnored public let networkingService: NetworkingService
//    @ObservationIgnored public let routerService: RouterServiceProtocol
//    
//    public private(set) var items: [Int] = []
//    public private(set) var title: String = ""
//    
//    var selectemItem: Int?
//    
//    weak var router: ListRouting?
//    
//    public init(networkingService: NetworkingService, routerService: RouterServiceProtocol) {
//        self.networkingService = networkingService
//        self.routerService = routerService
//    }
//    
//    public override func didBecomeActive() {
//        super.didBecomeActive()
//        fetchData()
//    }
//    
//    private func fetchData() {
//        title = networkingService.fetchTitle()
//        items = Array(1...100)
////        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
////            self.selectemItem = 1
////        })
//    }
//}

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

#Preview {
    // For the preview, we need a mock RouterService as well
//    let store = Store()
//    store.register({ Mock() }, forMetaType: NetworkingService.self)
//    let routerService = RouterService(store: store)
//    
//    return ListView(networkingService: Mock(), routerService: routerService)
}

struct ListView: View {
    
    @State var showDetails = false
    @State var showSimpleTextRIB = false
    
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
    
    //picked list bg color of element

    public var body: some View {
        NavigationStack {
            List(Array(1...50), id: \.self) { item in
                Button("Element \(item)") {
                    //nav path?
                    showSimpleTextRIB = true
                }
                .padding(.vertical, 4)
            }
            .navigationDestination(isPresented: $showSimpleTextRIB, destination: {
                SelectionRIBRepresentable()
            })
            .navigationTitle("List")
            
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
        }
        
//        EmptyView()
//            .tabRouteTo(tabItems: [
//                TabItem(label: "Menu", systemImage: "list.dash", route: HomeTabRoute()),
//                TabItem(label: "Order", systemImage: "square.and.pencil", route: OrderTabRoute())
//            ])
    }
}


struct RouteTabItem: View {
    let route: Route
    
    init(route: Route) {
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

// List ->
