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
    
    @State var selection: SummarySelection = SummarySelection(value: "")
    @State var selectionModel: SelectionSelection = SelectionSelection(value: "")
    @Injected(\.router) private var router
    
    //picked list bg color of element
    
    public var body: some View {
        List(1...50, id: \.self) { item in
            NavigationLink(
                route: SelectionRoute(selection: .constant(SelectionSelection(value: "Element \(item)")))
            ) {
                Text("Element \(item)")
                    .padding(.vertical, 4)
            }
        }
        .navigationTitle("List")
        .navigationBarTitleDisplayMode(.inline)
        
        //        NavigationStack {
        ////            Button("Show details") {
        ////                showDetails = true
        ////            }
        ////            .routeTo(
        ////                route: RentDetailsRoute(selection: $selection),
        ////                isActive: $showDetails,
        ////                style: .push
        ////            )
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


