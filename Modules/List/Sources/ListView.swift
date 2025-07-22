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
    
//    @State var selection: SummarySelection = SummarySelection(value: "")
    @State var selectionModel: SelectionValue = SelectionValue(value: "")
    
    @Injected(\.router) private var router
    
    @State private var showModal = false
    @State private var currentModalRoute: (any Route)? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    public var body: some View {
        RouteNavigationStack(path: $navigationPath) {
            VStack {
                List(1...50, id: \.self) { item in
                    NavigationLink(route: SelectionRoute(selection: .constant(SelectionValue(value: "Element \(item)")))) {
                        Text("Element \(item)")
                            .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                
                Button("Go to Order") {
                    navigationPath.push(to: OrderRoute())
                }.padding(8)
            }
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .routeTo(route: currentModalRoute ?? SelectionRoute(selection: .constant(SelectionValue(value: "Fallback"))), isActive: $showModal, style: .sheet)
        .onReceive(router.deepLinkPublisher) { route in
            currentModalRoute = route
            showModal = true
        }
        .onOpenURL { url in
            _ = router.handle(deepLink: url)
        }
        .onAppear {
            router.registerDeepLink(pathPrefix: "selection") { url in
                let urlString = url.absoluteString
                if let id = urlString.split(separator: "/").last {
                    return SelectionRoute(selection: .constant(SelectionValue(value: "Deep Link ID: \(id)")))
                }
                return nil
            }
        }
        //
        //         TODO: This is also possible
        //                NavigationStack(path: $navigationPath) {
        //                    List(1...50, id: \.self) { item in
        //                        NavigationLink(
        //                            route: SelectionRoute(selection: .constant(SelectionSelection(value: "Element \(item)"))),
        //                            navigationPath: $navigationPath
        //                        ) {
        //                            Text("Element \(item)")
        //                                .padding(.vertical, 4)
        //                        }
        //
        //                        NavigationLink(
        //                            route: OrderRoute(),
        //                            navigationPath: $navigationPath
        //                        ) {
        //                            Text("Order \(item)")
        //                                .padding(.vertical, 4)
        //                        }
        //                    }
        //                    .navigationTitle("List")
        //                }
        
        //        TabView {
        //            RouteTabItem(
        //                route: HomeRoute()
        //            )
        //            RouteTabItem(
        //                route: OrderRoute()
        //            )
        //        }
        
    }
}

//struct RouteTabItem: View {
//    let route: any Route
//
//    init(route: any Route) {
//        self.route = route
//    }
//
//    var body: some View {
//        route.getBuilder().buildView()
//    }
//}
