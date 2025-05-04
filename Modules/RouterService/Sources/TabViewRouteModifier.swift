import SwiftUI
import Factory

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