import Foundation
import SwiftUI
import NetworkingInterface
import RouterService
import Factory
import UIKit
import RIBs
import DetailsInterface
import ListInterface
import HomeInterface
import OrderInterface
 
import ExampleRIB

public class ListBuilder: ListBuildable {
    @Injected(\.networkingService) private var networkingService
    @Injected(\.router) private var router
    
    public init() {}
    
    public func buildView(fromRoute route: Route?) -> AnyView {
        return AnyView(
            ListView()
        )
    }
}
