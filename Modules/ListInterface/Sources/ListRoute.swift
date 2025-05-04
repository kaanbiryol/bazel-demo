import Foundation
import Factory
import RouterService

public struct ListRoute: Route {
    public static var identifier: String = "list_route"
    
    public func getBuilder() -> Builder2 {
        return Container.shared.listBuilder()
    }
    
    public init() {}
}
