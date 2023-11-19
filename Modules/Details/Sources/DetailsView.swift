import Foundation
import SwiftUI

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
            Spacer(minLength: 16)
            Text("Selected element \(element)")
        }
        .padding()
        .navigationTitle("Details")
    }
}

#Preview {
    DetailsView(element: 1)
}
