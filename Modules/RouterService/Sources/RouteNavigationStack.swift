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
                    router.view(for: anyRoute.base)
                        .environment(\.presentationStyle, .push)
                        .environment(\.navigationPath, $path)
                }
        }
    }
}

