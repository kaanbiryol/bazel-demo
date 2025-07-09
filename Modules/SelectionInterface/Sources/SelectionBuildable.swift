import Factory
import RouterService
import struct SwiftUI.Binding

public protocol SelectionBuildable: Builder2 {}

public extension Container {
    var selectionBuilder: ParameterFactory<Binding<SelectionSelection>, SelectionBuildable> {
    ParameterFactory(self) { _ in
      fatalError("🚨 SelectionService not registered – make sure your App registers one.")
    }
  }
} 