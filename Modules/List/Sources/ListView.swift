import Foundation
import SwiftUI
import NetworkingInterface
import DetailsInterface
import RouterService
import Factory
import UIKit
import RIBs




// Feature implementation for ListView
public struct ListFeature: Feature {
    @Dependency var networkingService: NetworkingService
    @Dependency var routerService: RouterServiceProtocol
    
    public init() {}
    
    // UIKit implementation - required by Feature protocol
    public func build(fromRoute route: Route?) -> UIViewController {
        let listView = ListView(networkingService: networkingService, routerService: routerService)
        return UIHostingController(rootView: listView)
    }
    
    // SwiftUI implementation
    public func buildSwiftUIView(fromRoute route: Route?) -> AnyView? {
        return AnyView(
            ListView(networkingService: networkingService, routerService: routerService)
        )
    }
}

public struct ListView: View {
    private let networkingService: NetworkingService
    private let routerService: RouterServiceProtocol
    @State private var selectedElement: Int?
    
    public init(networkingService: NetworkingService, routerService: RouterServiceProtocol) {
        self.networkingService = networkingService
        self.routerService = routerService
    }
    
    public var body: some View {
        NavigationView {
            List {
                ForEach(1..<101) { element in
//                    Button {
//                        selectedElement = element
//                    } label: {
//                        Text("Element \(element)")
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .contentShape(Rectangle())
//                    }
//                    .buttonStyle(.plain)
                    ListItem(element: element, routerService: routerService)
                }
            }
            .navigationBarTitle(networkingService.fetchTitle())
            .navigateTo(
                using: routerService,
                route: DetailsRoute(element: selectedElement ?? 0),
                isActive: Binding(
                    get: { selectedElement != nil },
                    set: { if !$0 { selectedElement = nil } }
                ),
                style: .sheet
            )
        }
    }
}

// Using standard button navigation with RouterService
struct ListItem: View {
    let element: Int
    let routerService: RouterServiceProtocol
    
    var body: some View {
        Button {
            // No need to set a binding, directly navigate with a link
        } label: {
            Text("Element \(element)")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .navigationLink(
            using: routerService,
            route: DetailsRoute(element: element)
        ) {
            Text("Element \(element)")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

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

struct ListModel {
    static let value = 100
}

