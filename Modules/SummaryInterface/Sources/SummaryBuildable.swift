import Factory
import RouterService
import struct SwiftUI.Binding

public protocol SummaryBuildable: Builder2 {}

public extension Container {
    var summaryBuilder: ParameterFactory<Binding<SummarySelection>, SummaryBuildable> {
    ParameterFactory(self) { _ in
      fatalError("🚨 NetworkingService not registered – make sure your App registers one.")
    }
  }
}
