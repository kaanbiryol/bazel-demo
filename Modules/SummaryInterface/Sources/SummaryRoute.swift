import Factory
import Foundation
import RouterService
import struct SwiftUI.Binding

public struct SummaryRoute: Route {
    public static var identifier: String = "rent_details_route"
    
    public let selection: Binding<SummarySelection>
    
    public init(selection: Binding<SummarySelection>) {
        self.selection = selection
    }
    
    public func getBuilder() -> any Builder2 {
        return Container.shared.summaryBuilder(selection)
    }
}

public struct SummarySelection {
    public var value: String
    
    public init(value: String) {
        self.value = value
    }
}
