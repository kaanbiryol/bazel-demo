import SwiftUI
import RouterService
import SelectionInterface

public class SelectionBuilder: SelectionBuildable {
//    @Injected(\.networkingService) private var networkingService
//    @Injected(\.router) private var router
    
    private var selectionBinding: Binding<SelectionSelection>
    private var listener: SelectionViewRIBListener?
    
    public init(selectionBinding: Binding<SelectionSelection>, listener: SelectionViewRIBListener?) {
        self.selectionBinding = selectionBinding
        self.listener = listener
    }
    
    public func buildView() -> AnyView {
        return AnyView(
            SelectionView(
                selection: selectionBinding,
                listener: listener
            )
        )
    }
} 
