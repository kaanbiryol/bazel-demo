import SwiftUI
import ListInterface

struct RootSwiftUI: View {
    @State private var showList = true // Always true to embed directly
    
    var body: some View {
        NavigationStack {
            EmptyView().navigationTitle("Root")
            .routeTo(
                route: ListRoute(),
                isActive: $showList,
                style: .embed)
        }
    }
} 
