import Factory
import RouterService
import struct SwiftUI.Binding

public protocol RentDetailsBuildable: Builder2 {}

public extension Container {
    var rentDetailsBuilder: ParameterFactory<Binding<SummarySelection>, RentDetailsBuildable> {
    ParameterFactory(self) { _ in
      fatalError("🚨 NetworkingService not registered – make sure your App registers one.")
    }
  }
}
