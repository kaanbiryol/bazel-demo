import SwiftUI
import Factory

public struct RouteDestinationView: View {
    let route: Route
    let navigationPath: Binding<NavigationPath>
    @Injected(\.router) private var router

    public var body: some View {
        if let view = router.view(for: route) {
            view
                .environment(\.navigationPath, navigationPath)
        } else {
            AnyView(EmptyView())
        }
    }
}

// MARK: - Convenience initialisers on NavigationLink
public extension NavigationLink where Destination == RouteDestinationView {

    public init(route: Route,
         navigationPath: Binding<NavigationPath>,
         @ViewBuilder label: () -> Label
    ) {
        self.init(
            destination: RouteDestinationView(route: route, navigationPath: navigationPath),
            label: label
        )
    }
}
