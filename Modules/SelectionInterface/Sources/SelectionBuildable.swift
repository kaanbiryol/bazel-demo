import Factory
import RouterService
import struct SwiftUI.Binding

public protocol SelectionViewRIBListener: AnyObject {
    func didTapContinueToSummary(with selectionValue: String)
}

public protocol SelectionBuildable: RouteBuilder {}

public extension Container {
    var selectionBuilder: ParameterFactory<(Binding<SelectionValue>, SelectionViewRIBListener?), SelectionBuildable> {
    ParameterFactory(self) { _ in
      fatalError("🚨 SelectionService not registered – make sure your App registers one.")
    }
  }
} 
