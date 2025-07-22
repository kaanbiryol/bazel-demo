import Factory
import Foundation
import RouterService
import struct SwiftUI.Binding

public struct SummaryRoute: Route {
    public static var identifier: String = "rent_details_route"
    
    public let selection: Binding<SummaryValue>
    
    public init(selection: Binding<SummaryValue>) {
        self.selection = selection
    }
    
    public func getBuilder() -> any RouteBuilder {
        return Container.shared.summaryBuilder((selection, nil))
    }
}

public struct SummaryValue {
    public var value: String
    
    public init(value: String) {
        self.value = value
    }
}
