import SwiftUI
import Factory

public struct RouteDestinationView: View {
    let route: any Route
    let navigationPath: Binding<NavigationPath>
    @Injected(\.router) private var router
    
    public var body: some View {
        router.view(for: route)
            .environment(\.navigationPath, navigationPath)
    }
}

public extension NavigationLink where Destination == RouteDestinationView {
    
    init(route: any Route,
         navigationPath: Binding<NavigationPath>,
         @ViewBuilder label: () -> Label
    ) {
        self.init(
            destination: RouteDestinationView(route: route, navigationPath: navigationPath),
            label: label
        )
    }
}
