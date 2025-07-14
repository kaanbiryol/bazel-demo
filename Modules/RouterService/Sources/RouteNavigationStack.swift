import SwiftUI
import Factory

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
                    } else {
                        EmptyView()
                    }
                }
        }
    }
}

