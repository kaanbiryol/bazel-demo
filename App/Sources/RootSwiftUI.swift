import SwiftUI
import ListInterface
import Factory // If not already imported

struct RootSwiftUI: View {
    @Injected(\.router) private var router // Inject the router
    @State private var showList = true // Always true to embed directly
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            EmptyView().navigationTitle("Root")
                    .routeTo(
            route: ListRoute(),
            isActive: $showList,
            style: .embed)
    }
        
//        .environment(\.navigateToRoot) {
//            navigationPath = NavigationPath()
//        }
        .environment(\.navigationPath, $navigationPath)
    }
} 
