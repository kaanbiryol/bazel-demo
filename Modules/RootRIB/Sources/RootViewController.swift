import RIBs
import UIKit

// MARK: - RootViewController
final class RootViewController: UIViewController, RootViewControllable, RootPresentable {
    
    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func embedViewController(_ viewController: any ViewControllable) {
        let childViewController = viewController.uiViewController
        addChild(childViewController)
        view.addSubview(childViewController.view)
        
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        childViewController.didMove(toParent: self)
    }
    
    func unembedViewController(_ viewController: any ViewControllable) {
        let childViewController = viewController.uiViewController
        guard childViewController.parent == self else { return }
        
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}
