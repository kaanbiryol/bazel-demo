import UIKit
import SwiftUI

public final class SwiftUIViewControllable: ViewControllable {
    public var uiViewController: UIViewController
    
    public init(_ view: some View) {
        self.uiViewController = UIHostingController(rootView: view)
    }
}
