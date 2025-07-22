import Factory
import RouterService
import struct SwiftUI.Binding

public protocol SummaryViewRIBListener: AnyObject {
    func didTapPopBack()
    func didTapPopToRoot()
    func didTapDone()
}

public protocol SummaryBuildable: RouteBuilder {}

public extension Container {
    var summaryBuilder: ParameterFactory<(Binding<SummaryValue>, SummaryViewRIBListener?), SummaryBuildable> {
    ParameterFactory(self) { _ in
      fatalError("🚨 SummaryService not registered – make sure your App registers one.")
    }
  }
}
