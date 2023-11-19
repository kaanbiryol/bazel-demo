import Foundation
import SwiftUI
import DataStore
import Details

public struct ListView: View {

    public init() {}

    public var body: some View {
        NavigationView {
            List {
                ForEach(1..<101) { element in
                    NavigationLink(destination: DetailsView(element: element)) {
                        Text("Element \(element)")
                    }
                }
            }
            .navigationBarTitle(DataStore.title)
        }
    }
}

#Preview {
    ListView()
}

struct ListModel {
    static let value = 100
}
