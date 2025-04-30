import Foundation
import SwiftUI

public protocol Route {
    static var identifier: String { get }
    func getBuilder() -> any Builder2
}

public protocol Builder2 {
    func buildView(fromRoute route: Route?) -> AnyView?
}

