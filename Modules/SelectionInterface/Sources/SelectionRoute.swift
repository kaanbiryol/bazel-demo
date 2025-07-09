import Factory
import Foundation
import RouterService
import struct SwiftUI.Binding

public struct SelectionRoute: Route {
    public static var identifier: String = "selection_route"
    
    public let selection: Binding<SelectionSelection>
    
    public init(selection: Binding<SelectionSelection>) {
        self.selection = selection
    }
    
    public func getBuilder() -> any Builder2 {
        return Container.shared.selectionBuilder(selection)
    }
}

public struct SelectionSelection {
    public var value: String
    
    public init(value: String) {
        self.value = value
    }
} 