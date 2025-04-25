import Foundation
import RouterService
import DetailsInterface
import SwiftUI

public class DetailsRouteHandler: RouteHandler {
    public var routes: [Route.Type] {
        return [DetailsRoute.self]
    }

    public func destination(
        forRoute route: Route,
        fromViewController: UIViewController?
    ) -> Feature.Type {
        return DetailsFeature.self
    }

    public init() {}
}
