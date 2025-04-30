import UIKit
import SwiftUI

/// Basic interface between a `Router` and the UIKit `UIViewController`.
/// @mockable
public protocol ViewControllable: AnyObject {
    var uiViewController: UIViewController { get }
    var view: (any View)? { get }
}

/// Default implementation on `UIViewController` to conform to `ViewControllable` protocol
extension ViewControllable where Self: UIViewController {
    public var uiViewController: UIViewController {
        self
    }
}

extension ViewControllable where Self: View {
    public var view: any View {
        self
    }
}
