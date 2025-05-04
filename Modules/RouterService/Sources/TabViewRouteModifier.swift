import SwiftUI
import Factory

// Protocol for routes that provide tab information
public protocol TabLabelProvider {
    var tabLabel: String { get }
    var tabIcon: String { get }
}


// Helper extension to erase type
extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// Simplify RouteView
struct RouteView: View {
    let route: Route
    
    init(_ route: Route) {
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


extension Route where Self: View {
    public var body: some View {
        let routeView = RouteView(self)
        
        if let self = self as? TabLabelProvider {
            return routeView
                .tabItem {
                    Label(self.tabLabel, systemImage: self.tabIcon)
                }
                .eraseToAnyView()
        } else {
            return routeView.eraseToAnyView()
        }
    }
}

// Clean up extensions
extension Route {
    func tabItem(label: String, systemImage: String) -> some View {
        RouteView(self)
            .tabItem {
                Label(label, systemImage: systemImage)
            }
    }
}



public struct TabItem {
    let label: String
    let systemImage: String
    let route: Route
    
    public init(label: String, systemImage: String, route: Route) {
        self.label = label
        self.systemImage = systemImage
        self.route = route
    }
}

public struct TabViewRouteModifier: ViewModifier {
    let router: Router
    let tabItems: [TabItem]
    
    public func body(content: Content) -> some View {
        TabView {
            ForEach(0..<tabItems.count, id: \.self) { index in
                let item = tabItems[index]
                if let view = router.view(for: item.route) {
                    view
                        .tabItem {
                            Label(item.label, systemImage: item.systemImage)
                        }
                } else {
                    EmptyView()
                        .tabItem {
                            Label(item.label, systemImage: item.systemImage)
                        }
                }
            }
        }
    }
}

public extension View {
    func tabRouteTo(
        using router: Router,
        tabItems: [TabItem]
    ) -> some View {
        self.modifier(TabViewRouteModifier(
            router: router,
            tabItems: tabItems
        ))
    }
    
    // Convenience method using Factory
    func tabRouteTo(
        tabItems: [TabItem]
    ) -> some View {
        self.modifier(TabViewRouteModifier(
            router: Container.shared.router(),
            tabItems: tabItems
        ))
    }
} 
