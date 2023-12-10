import Foundation
import SwiftUI
import NetworkingInterface

public struct DetailsView: View {
    let element: Int

    public init(element: Int) {
        self.element = element
    }

    public var body: some View {
        VStack {
            Image("bazel", bundle: .details)
                .resizable()
                .frame(width: 100, height: 100)
            Text("Selected element23 \(element)")
        }
        .padding()
//        .navigationTitle(NetworkingImpl().fetchDetails())
    }
    
    private func test() -> String {
        "KAAN2"
    }
}

#Preview {
    DetailsView(element: 1)
}
