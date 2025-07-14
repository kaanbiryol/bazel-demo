import SwiftUI
import Factory

extension EnvironmentValues {
    @Entry public var presentationStyle: NavigationStyle = .push(.constant(.init()))
    @Entry public var navigationPath: Binding<NavigationPath> = .constant(NavigationPath())
    @Entry public var routeNavigator: RouteNavigator = RouteNavigator()
}

public class RouteNavigator: ObservableObject {
    private var navigationPath: Binding<NavigationPath>?
    
    public init() {}
    
    internal func setNavigationPath(_ path: Binding<NavigationPath>) {
        self.navigationPath = path
    }
    
    public func navigate(to route: Route) {
        guard let navigationPath = navigationPath else { return }
        navigationPath.wrappedValue.append(route)
    }
    
    public func navigateBack() {
        guard let navigationPath = navigationPath else { return }
        _ = navigationPath.wrappedValue.removeLast()
    }
    
    public func navigateToRoot() {
        guard let navigationPath = navigationPath else { return }
        navigationPath.wrappedValue.removeLast(navigationPath.wrappedValue.count)
    }
}

public struct RouteModifier: ViewModifier {
    // @InjectedObject(\.router) private var router
    let router: Router
    let route: Route
    @Binding var isActive: Bool
    let style: NavigationStyle
    
    public func body(content: Content) -> some View {
        VStack {
            content
            if style == .embed && isActive {
                routeDestination()
                    .environment(\.presentationStyle, .embed)
                    .environment(\.navigationPath, getNavigationPath())
                    .environment(\.routeNavigator, createRouteNavigator())
            }
        }
        .background(
            ZStack {
                if case let .push(navigationPath) = style {
                    NavigationLink(
                        destination: routeDestination()
                            .environment(\.presentationStyle, .push(navigationPath))
                            .environment(\.navigationPath, navigationPath)
                            .environment(\.routeNavigator, createRouteNavigator()),
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
                .environment(\.presentationStyle, .sheet)
                .environment(\.navigationPath, getNavigationPath())
                .environment(\.routeNavigator, createRouteNavigator())
        }
        .fullScreenCover(isPresented: style == .fullScreenCover ? $isActive : .constant(false)) {
            routeDestination()
                .environment(\.presentationStyle, .fullScreenCover)
                .environment(\.navigationPath, getNavigationPath())
                .environment(\.routeNavigator, createRouteNavigator())
        }
    }
    
    private func routeDestination() -> AnyView {
        return router.view(for: route) ?? AnyView(EmptyView())
    }
    
    private func routeDestination(for route: Route) -> AnyView {
        return router.view(for: route) ?? AnyView(EmptyView())
    }
    
    private func getNavigationPath() -> Binding<NavigationPath> {
        if case let .push(navigationPath) = style {
            return navigationPath
        }
        // For non-push navigation styles, return a default navigation path
        return .constant(NavigationPath())
    }
    
    private func createRouteNavigator() -> RouteNavigator {
        let navigator = RouteNavigator()
        navigator.setNavigationPath(getNavigationPath())
        return navigator
    }
}

public enum NavigationStyle {
    case push(_ navigationPath: Binding<NavigationPath>)
    case sheet
    case fullScreenCover
    case embed
}

extension NavigationStyle: Equatable {
    public static func == (lhs: NavigationStyle, rhs: NavigationStyle) -> Bool {
        switch (lhs, rhs) {
        case (.push, .push): return true
        case (.sheet, .sheet): return true
        case (.fullScreenCover, .fullScreenCover): return true
        case (.embed, .embed): return true
        default: return false
        }
    }
}

public extension View {
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
    
    func routeTo(
        route: Route,
        isActive: Binding<Bool>,
        navigationPath: Binding<NavigationPath>
    ) -> some View {
        self.modifier(RouteModifier(
            router: Container.shared.router(),
            route: route,
            isActive: isActive,
            style: .push(navigationPath)
        ))
    }

     func routeNavigationDestination() -> some View {
        self.navigationDestination(for: AnyRoute.self) { anyRoute in
            if let view = Container.shared.router().view(for: anyRoute.base) {
                view
                    .environment(\.navigationPath, .constant(NavigationPath())) // Placeholder; ideally inject from parent
                    .environment(\.routeNavigator, RouteNavigator()) // Placeholder
            } else {
                EmptyView()
            }
        }
    }

}

public struct RouteNavigationStack<Content: View>: View {
    
    @Binding var path: NavigationPath
    
    let content: () -> Content
    
    @Injected(\.router) private var router
    
    public init(path: Binding<NavigationPath>, @ViewBuilder content: @escaping () -> Content) {
        self._path = path
        self.content = content
    }
    
    public var body: some View {
        NavigationStack(path: $path) {
            content()
                .navigationDestination(for: AnyRoute.self) { anyRoute in
                    if let view = router.view(for: anyRoute.base) {
                        view
                            .environment(\.navigationPath, $path)
                            .environment(\.routeNavigator, createRouteNavigator())
                    } else {
                        EmptyView()
                    }
                }
        }
    }
    
    private func createRouteNavigator() -> RouteNavigator {
        let navigator = RouteNavigator()
        navigator.setNavigationPath($path)
        return navigator
    }
}

public struct AnyRoute: Hashable {
    private let _hash: (inout Hasher) -> Void
    private let _equals: (Any) -> Bool
    public let base: any Route

    public init<R: Route>(_ route: R) {
        self.base = route
        _hash = { route.hash(into: &$0) }
        _equals = { ($0 as? R) == route }
    }
    public func hash(into hasher: inout Hasher) { _hash(&hasher) }
    public static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.base == rhs.base
    }
}

public extension NavigationPath {
    
    mutating func push(to route: any Route) {
        self.append(AnyRoute(route))
    }
    
    mutating func pop() {
        self.removeLast()
    }
    
//    mutating func append<R: Route>(_ route: R) {
//        self.append(AnyRoute(route))
//    }
    
    mutating func popToRoot() {
        self = NavigationPath()
    }
}

public extension Binding where Value == NavigationPath {
    func push<R: Route>(_ route: R) {
        self.wrappedValue.append(AnyRoute(route))
    }
    
    func pop() {
        if !self.wrappedValue.isEmpty {
            self.wrappedValue.removeLast()
        }
    }
    
    func popToRoot() {
        self.wrappedValue.removeLast(self.wrappedValue.count)
    }
}

public extension NavigationLink where Destination == Never {
    init<R: Route>(route: R, @ViewBuilder label: () -> Label) {
        self.init(value: AnyRoute(route), label: label)
    }
}

