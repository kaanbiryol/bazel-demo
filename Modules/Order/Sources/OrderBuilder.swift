import Foundation
import SwiftUI
import RouterService
import Factory
import OrderInterface

public class OrderBuilder: OrderBuildable {
    public init() {}
    
    public func buildView() -> AnyView {
        return AnyView(OrderView())
    }
}

struct OrderView: View {
    public var body: some View {
        VStack {
            Text("Order Tab")
            Image(systemName: "square.and.pencil")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
        }
        .tabItem {
            Label("Orders", systemImage: "square.and.pencil")
        }
    }
}
