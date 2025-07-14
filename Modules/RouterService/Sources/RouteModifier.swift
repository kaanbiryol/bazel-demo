import SwiftUI
import Factory

public struct RouteModifier: ViewModifier {
     
    @Injected(\.router) private var router
    @Binding var isActive: Bool
    
    let route: any Route
    let style: NavigationStyle
    
    public func body(content: Content) -> some View {
        VStack {
            content
            if style == .embed && isActive {
                routeDestination()
                    .environment(\.presentationStyle, .embed)
            }
        }
        .background(
//            ZStack {
//                if case let .push(navigationPath) = style {
//                    NavigationLink(
//                        destination: routeDestination()
//                            .environment(\.presentationStyle, .push(navigationPath))
//                            .environment(\.navigationPath, navigationPath),
//                        isActive: $isActive
//                    ) {
//                        EmptyView()
//                    }
//                    .hidden()
//                }
//            }
        )
        .sheet(isPresented: style == .sheet ? $isActive : .constant(false)) {
            routeDestination()
                .environment(\.presentationStyle, .sheet)
        }
        .fullScreenCover(isPresented: style == .fullScreenCover ? $isActive : .constant(false)) {
            routeDestination()
                .environment(\.presentationStyle, .fullScreenCover)
        }
    }
    
    private func routeDestination() -> AnyView {
        return router.view(for: route) ?? AnyView(EmptyView())
    }
}

public extension View {
    func routeTo(
        route: any Route,
        isActive: Binding<Bool>,
        style: NavigationStyle
    ) -> some View {
        self.modifier(RouteModifier(
            isActive: isActive,
            route: route,
            style: style
        ))
    }
}
