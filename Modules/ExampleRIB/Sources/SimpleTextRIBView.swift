import SwiftUI
import UIKit
import RIBs

// UIViewControllerRepresentable for SimpleTextRIB
public struct SimpleTextRIBView: UIViewControllerRepresentable {
    public init() {}
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let builder = SimpleTextBuilder()
        let router = builder.build()
        return router.viewControllable.uiViewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Nothing to update
    }
} 
