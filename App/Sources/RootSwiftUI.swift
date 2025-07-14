import SwiftUI
import ListInterface
import Factory

struct RootSwiftUI: View {
    @Injected(\.router) private var router
    
    @State private var showList = true
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            EmptyView().navigationTitle("Root")
                .routeTo(
                    route: ListRoute(),
                    isActive: $showList,
                    style: .embed
                )
        }
        .environment(\.navigationPath, $navigationPath)
    }
}
