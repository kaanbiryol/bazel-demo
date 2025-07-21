import Foundation
import SwiftUI

public protocol Route: Hashable {
    func getBuilder() -> any RouteBuilder
}

public protocol RouteBuilder {
    func buildView() -> AnyView
}

public extension Route {
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
