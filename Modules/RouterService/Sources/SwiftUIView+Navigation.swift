import SwiftUI

/// Defines the style of navigation to be used
public enum NavigationStyle {
    /// Push navigation using NavigationLink
    case push
    /// Present as a sheet
    case sheet
    /// Present as a full screen cover
    case fullScreenCover
}

// MARK: - Navigation Extensions

extension View {
    /// Navigate to a destination defined by a route
    public func navigateTo(
        using routerService: RouterServiceProtocol,
        route: Route,
        isActive: Binding<Bool>,
        style: NavigationStyle = .push
    ) -> some View {
        guard let destinationView = routerService.view(forRoute: route) else {
            // Return self unchanged if no view is available for this route
            return AnyView(self)
        }

        // Apply modal modifiers directly to self
        // Use conditional bindings to only activate the relevant modifier
        return AnyView(
            self
                .background( // Use background for the hidden NavigationLink for .push
                    ZStack {
                        if style == .push {
                            NavigationLink(
                                destination: destinationView,
                                isActive: isActive
                            ) {
                                EmptyView()
                            }
                            .hidden() // Keep it hidden
                        }
                    }
                )
                // Apply sheet modifier conditionally
                .sheet(isPresented: style == .sheet ? isActive : .constant(false)) {
                    destinationView
                }
                // Apply fullScreenCover modifier conditionally
                .fullScreenCover(isPresented: style == .fullScreenCover ? isActive : .constant(false)) {
                    destinationView
                }
        )
    }
    
    /// Create a link that navigates to a destination defined by a route
    public func navigationLink<Label: View>(
        using routerService: RouterServiceProtocol, 
        route: Route,
        @ViewBuilder label: @escaping () -> Label
    ) -> some View {
        guard let destinationView = routerService.view(forRoute: route) else {
            // Return self unchanged if no view is available for this route
            return AnyView(self)
        }
        
        return AnyView(
            NavigationLink(destination: destinationView) {
                label()
            }
        )
    }
    
    /// Present a sheet for a route when a condition is true
    public func sheet(
        using routerService: RouterServiceProtocol,
        route: Route,
        isPresented: Binding<Bool>
    ) -> some View {
        guard let destinationView = routerService.view(forRoute: route) else {
            // Return self unchanged if no view is available for this route
            return AnyView(self)
        }
        
        return AnyView(
            self.sheet(isPresented: isPresented) {
                destinationView
            }
        )
    }
    
    /// Present a fullScreenCover for a route when a condition is true
    public func fullScreenCover(
        using routerService: RouterServiceProtocol,
        route: Route,
        isPresented: Binding<Bool>
    ) -> some View {
        guard let destinationView = routerService.view(forRoute: route) else {
            // Return self unchanged if no view is available for this route
            return AnyView(self)
        }
        
        return AnyView(
            self.fullScreenCover(isPresented: isPresented) {
                destinationView
            }
        )
    }
}
