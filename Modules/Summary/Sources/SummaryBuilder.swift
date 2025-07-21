import SwiftUI
import RouterService
import SummaryInterface

public class SummaryBuilder: SummaryBuildable {
//    @Injected(\.networkingService) private var networkingService
//    @Injected(\.router) private var router
    
    private var selectionBinding: Binding<SummarySelection>
    private var listener: SummaryViewRIBListener?
    
    public init(selectionBinding: Binding<SummarySelection>, listener: SummaryViewRIBListener?) {
        self.selectionBinding = selectionBinding
        self.listener = listener
    }
    
    public func buildView() -> AnyView {
        return AnyView(
            SummaryView(
                selection: selectionBinding,
                listener: listener
            )
        )
    }
}
