import Foundation

public protocol DetailsViewControllerInterface {
    func displayItem(_ item: DetailItem)
    func displayLoading(_ isLoading: Bool)
    func displayError(_ message: String)
}

public protocol DetailsPresenterInterface {
    func viewDidLoad()
    func didTapBackButton()
}

public struct DetailItem {
    public let id: String
    public let title: String
    public let description: String
    public let imageURL: URL?
    public let additionalInfo: String?
    
    public init(id: String, title: String, description: String, imageURL: URL? = nil, additionalInfo: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.additionalInfo = additionalInfo
    }
} 

//// Feature implementation for DetailsView
//public struct DetailsFeature: Feature {
//    private let element: Int
//
//    public init(element: Int) {
//        self.element = element
//    }
//
//    public init() {
//        self.element = 0
//    }
//
//    public func build(fromRoute route: Route?) -> some View {
//        DetailsView(element: element)
//    }
//}
//
//public class Mock: NetworkingService {
//    public func fetchTitle() -> String {
//        return "List Items"
//    }
//
//    public func fetchDetails() -> String {
//        return "Details"
//    }
//
//    private func somethingElse() {}
//}
