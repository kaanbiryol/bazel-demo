import RIBs
import UIKit

// MARK: - RootViewController
final class RootViewController: UIViewController, RootViewControllable, RootPresentable {
    
    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Root"
        view.backgroundColor = .systemBackground
    }
    
    func embedViewController(_ viewController: any ViewControllable) {
        let childVC = viewController.uiViewController
        
        // Proper view controller containment
        addChild(childVC)
        view.addSubview(childVC.view)
        
        // Set up constraints to fill the parent view
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            childVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Complete the containment relationship
        childVC.didMove(toParent: self)
    }
    
    func unembedViewController(_ viewController: any ViewControllable) {
        let childVC = viewController.uiViewController
        
        // Proper view controller containment removal
        guard childVC.parent == self else { return }
        
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
}
