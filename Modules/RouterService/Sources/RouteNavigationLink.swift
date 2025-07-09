import SwiftUI
import Factory

public struct RouteNavigationLink<Label: View>: View {
    let route: Route
    let label: () -> Label
    
    public init(route: Route, @ViewBuilder label: @escaping () -> Label) {
        self.route = route
        self.label = label
    }
    
    public var body: some View {
        NavigationLink {
            RouteDestinationView(route: route)
        } label: {
            label()
        }
    }
}

// Convenience initializer for text-only links
public extension RouteNavigationLink where Label == Text {
    init(_ title: String, route: Route) {
        self.init(route: route) {
            Text(title)
        }
    }
}

// MARK: - A view that resolves a Route to its actual destination
public struct RouteDestinationView: View {
    let route: Route
    @Injected(\.router) private var router

    public var body: some View {
        router.view(for: route) ?? AnyView(EmptyView())
    }
}

// MARK: - Convenience initialisers on NavigationLink
public extension NavigationLink
where Destination == RouteDestinationView {

    init(route: Route,
         @ViewBuilder label: () -> Label) {
        self.init(
            destination: RouteDestinationView(route: route),
            label: label
        )
    }
}

public extension NavigationLink where Destination == RouteDestinationView, Label == Text {

    /// Text-only version so you can write `NavigationLink("Profile", route: .profile)`
    init(_ title: String, route: Route) {
        self.init(route: route) {
            Text(title)
        }
    }
}

