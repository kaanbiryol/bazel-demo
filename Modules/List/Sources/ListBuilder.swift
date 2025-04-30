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


//// public final class RentCoreBuilder: Builder<RentCoreComponent, Void>, RentCoreBuildable {
//public final class TestBuilder: Builder<ListComponent, Void>, TestBuildable  {
//    
//    public func buildSwiftUIView() -> AnyView? {
//        let component = componentBuilder()
//        // component.something
//        return AnyView(Text(""))
//    }
//    
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

    //dismiss with dismiss()
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
        
        TabView {
            Text("TEST")
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            
            Text("TES2T")
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
        }
    }
}

