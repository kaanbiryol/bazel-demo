import Foundation
import SwiftUI

public struct DetailsView: View {
    let element: Int

    public init(element: Int) {
        self.element = element
    }

    public var body: some View {
        VStack {
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
