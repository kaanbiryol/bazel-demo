import Foundation
import Factory
import RouterService

public protocol ListBuildable: Builder2 {}

public extension Container {
    var listBuilder: Factory<ListBuildable> {
        Factory(self) {
            fatalError("🚨 NetworkingService not registered – make sure your App registers one.")
        }
    }
}

public struct ListRoute: Route {
    public static var identifier: String = "list_route"
    
    public func getBuilder() -> Builder2 {
        return Container.shared.listBuilder()
    }
    
    public init() {}
}
