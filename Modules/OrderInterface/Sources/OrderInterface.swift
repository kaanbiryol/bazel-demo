import Foundation
import SwiftUI
import RouterService
import Factory

public protocol OrderBuildable: Builder2 {}

// Order route definition
public struct OrderRoute: Route {
    public static var identifier: String { "order_tab" }
    
    public init() {}
    
    public func getBuilder() -> Builder2 {
        Container.shared.orderBuilder()
    }
}

public extension Container {
    var orderBuilder: Factory<OrderBuildable> {
        self { fatalError("OrderBuilder not registered") }
    }
} 
