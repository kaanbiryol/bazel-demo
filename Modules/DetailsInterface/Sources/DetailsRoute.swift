import Factory
import Foundation
import RouterService
import struct SwiftUI.Binding

public protocol RentDetailsBuildable: Builder2 {}

public extension Container {
    var rentDetailsBuilder: ParameterFactory<Binding<RentDetailsSelection>, RentDetailsBuildable> {
    ParameterFactory(self) { _ in
      fatalError("🚨 NetworkingService not registered – make sure your App registers one.")
    }
  }
}

public struct RentDetailsRoute: Route {
    public static var identifier: String = "rent_details_route"
    
    public let selection: Binding<RentDetailsSelection>
    
    public init(selection: Binding<RentDetailsSelection>) {
        self.selection = selection
    }
    
    public func getBuilder() -> any Builder2 {
        return Container.shared.rentDetailsBuilder(selection)
    }
    
}

public struct RentDetailsSelection {
    public var value: String
    
    public init(value: String) {
        self.value = value
    }
}
