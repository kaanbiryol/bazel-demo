import SwiftUI
import Factory

//// Custom data type to wrap routes for navigation
//public struct NavigationRoute: Hashable {
//    let route: Route
//    let id: String
//    
//    public init(route: Route, id: String = UUID().uuidString) {
//        self.route = route
//        self.id = id
//    }
//    
//    public static func == (lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//// Extension to make NavigationDestination work with routes
//public extension View {
//    func routeNavigationDestination() -> some View {
//        self.navigationDestination(for: NavigationRoute.self) { navRoute in
//            RouteDestinationView(route: navRoute.route)
//        }
//    }
//}
//
//// Helper view to render routes
//struct RouteDestinationView: View {
//    let route: Route
//    @Injected(\.router) private var router
//    
//    var body: some View {
//        router.view(for: route) ?? AnyView(EmptyView())
//    }
//} 
