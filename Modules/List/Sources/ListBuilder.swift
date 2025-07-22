import SwiftUI
import NetworkingInterface
import RouterService
import Factory
import ListInterface

public class ListBuilder: ListBuildable {
    @Injected(\.networkingService) private var networkingService
    @Injected(\.router) private var router
    
    public init() {}
    
    public func buildView() -> AnyView {
        return AnyView(
            ListView()
        )
    }
}
