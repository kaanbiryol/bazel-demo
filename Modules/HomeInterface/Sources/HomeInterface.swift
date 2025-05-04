import Foundation
import SwiftUI
import RouterService
import Factory

public protocol HomeBuildable: Builder2 {}

public struct HomeRoute: Route {
    public static var identifier: String { "home_tab" }
    
    public init() {}
    
    public func getBuilder() -> Builder2 {
        Container.shared.homeBuilder()
    }
}

public extension Container {
    var homeBuilder: Factory<HomeBuildable> {
        self { fatalError("HomeBuilder not registered") }
    }
} 
