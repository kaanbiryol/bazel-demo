import SwiftUI
import Factory

public struct RouteModifier: ViewModifier {
    // @InjectedObject(\.router) private var router
    let router: Router
    let route: Route
    @Binding var isActive: Bool
    let style: NavigationStyle
    
    public func body(content: Content) -> some View {
        VStack {
            content
            
            // Embed the route content directly when active
            if style == .embed && isActive {
                routeDestination()
            }
        }
        .background(
            ZStack {
                if style == .push {
                    NavigationLink(
                        destination: routeDestination(),
                        isActive: $isActive
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        )
        .sheet(isPresented: style == .sheet ? $isActive : .constant(false)) {
            routeDestination()
        }
        .fullScreenCover(isPresented: style == .fullScreenCover ? $isActive : .constant(false)) {
            routeDestination()
        }
    }
    
    private func routeDestination() -> AnyView {
        return router.view(for: route) ?? AnyView(EmptyView())
    }
}

public enum NavigationStyle: Equatable {
    case push
    case sheet
    case fullScreenCover
    case embed
}

public extension View {
    func routeTo(
        using router: Router,
        route: Route,
        isActive: Binding<Bool>,
        style: NavigationStyle
    ) -> some View {
        self.modifier(RouteModifier(
            router: router,
            route: route,
            isActive: isActive,
            style: style
        ))
    }
    
    // Convenience method using Factory
    func routeTo(
        route: Route,
        isActive: Binding<Bool>,
        style: NavigationStyle
    ) -> some View {
        self.modifier(RouteModifier(
            router: Container.shared.router(),
            route: route,
            isActive: isActive,
            style: style
        ))
    }
}
