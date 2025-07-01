import Foundation
import SwiftUI
import RouterService
import Factory
import HomeInterface

public class HomeBuilder: HomeBuildable {
    @Injected(\.router) private var router
    
    public init() {}
    
    public func buildView(fromRoute route: Route?) -> AnyView {
        return AnyView(HomeView())
    }
}

struct HomeView: View {
    public var body: some View {
        VStack {
            Text("Home Tab")
            Image(systemName: "house.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
        }
        .tabItem {
            Label("Home", systemImage: "house.fill")
        }
    }
}
