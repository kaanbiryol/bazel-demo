import Factory
import Foundation
import RouterService
import struct SwiftUI.Binding

public struct SelectionRoute: Route {
    
    public let selection: Binding<SelectionValue>
    
    public init(selection: Binding<SelectionValue>) {
        self.selection = selection
    }
    
    public func getBuilder() -> any RouteBuilder {
        return Container.shared.selectionBuilder((selection, nil))
    }
}

public struct SelectionValue {
    public var value: String
    
    public init(value: String) {
        self.value = value
    }
} 
