import SwiftUI
import RouterService
import SummaryInterface

public class SummaryBuilder: SummaryBuildable {
//    @Injected(\.networkingService) private var networkingService
//    @Injected(\.router) private var router
    
    private var selectionBinding: Binding<SummarySelection>
    
    public init(selectionBinding: Binding<SummarySelection>) {
        self.selectionBinding = selectionBinding
    }
    
    public func buildView() -> AnyView {
        return AnyView(
            SummaryView(selection: selectionBinding)
        )
    }
}
