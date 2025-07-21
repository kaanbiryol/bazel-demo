import Foundation

public struct AnyRoute: Hashable {
    private let _hash: (inout Hasher) -> Void
    private let _equals: (Any) -> Bool
    public let base: any Route

    public init<R: Route>(_ route: R) {
        self.base = route
        _hash = { route.hash(into: &$0) }
        _equals = { ($0 as? R) == route }
    }
    public func hash(into hasher: inout Hasher) { _hash(&hasher) }
    public static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.base.hashValue == rhs.base.hashValue
    }
}

