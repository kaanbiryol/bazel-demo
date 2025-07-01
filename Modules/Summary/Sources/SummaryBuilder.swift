import SwiftUI
import RouterService
import SummaryInterface

public class SummaryBuilder: RentDetailsBuildable {
//    @Injected(\.networkingService) private var networkingService
//    @Injected(\.router) private var router
    
    private var selectionBinding: Binding<SummarySelection>
    
    public init(selectionBinding: Binding<SummarySelection>) {
        self.selectionBinding = selectionBinding
    }
    
    public func buildView(fromRoute route: Route?) -> AnyView {
        return AnyView(
            SummaryView(selection: selectionBinding)
        )
    }
}
