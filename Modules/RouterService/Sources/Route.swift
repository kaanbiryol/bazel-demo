import Foundation
import SwiftUI

public protocol Route: Hashable {
    static var identifier: String { get }
    func getBuilder() -> any Builder2
}

// Default implementation of Hashable for Route
public extension Route {
    func hash(into hasher: inout Hasher) {
        hasher.combine(Self.identifier)
        hasher.combine(String(describing: self))
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

// Type-erased equality for different Route types
public func == (lhs: any Route, rhs: any Route) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public protocol Builder2 {
    func buildView(fromRoute route: Route?) -> AnyView
}
