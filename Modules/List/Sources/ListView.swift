import Foundation
import SwiftUI
import NetworkingInterface
import Details

public struct ListView: View {
    private let networkingService: any NetworkingService

    public init(networkingService: any NetworkingService) {
        self.networkingService = networkingService
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(1..<101) { element in
                    NavigationLink(destination: DetailsView(element: element)) {
                        Text("Element \(element)")
                    }
                }
            }
            .navigationBarTitle(networkingService.fetchTitle())
        }
    }
}

public class Mock: NetworkingService {
    public func fetchTitle() -> String {
        return ""
    }

    public func fetchDetails() -> String {
        return ""
    }

    private func somethingElse() {}
}

#Preview {
    ListView(networkingService: Mock())
}

struct ListModel {
    static let value = 100
}
