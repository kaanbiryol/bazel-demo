import Foundation
import Factory
import RouterService

public struct ListRoute: Route {
    public static var identifier: String = "list_route"
    
    public func getBuilder() -> RouteBuilder {
        return Container.shared.listBuilder()
    }
    
    public init() {}
}
