import SwiftUI
import RouterService
import SelectionInterface

public class SelectionBuilder: SelectionBuildable {
//    @Injected(\.networkingService) private var networkingService
//    @Injected(\.router) private var router
    
    private var selectionBinding: Binding<SelectionSelection>
    
    public init(selectionBinding: Binding<SelectionSelection>) {
        self.selectionBinding = selectionBinding
    }
    
    public func buildView(fromRoute route: Route?) -> AnyView {
        return AnyView(
            SelectionView(selection: selectionBinding)
        )
    }
} 