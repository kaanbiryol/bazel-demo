import RIBs
import UIKit

// MARK: - ListInteractable
public protocol ListInteractable: Interactable {
    var router: ListRouting? { get set }
    func didSelectItem(_ item: Int)
}

// MARK: - ListViewControllable
public protocol ListViewControllable: ViewControllable {
    func showItems(_ items: [Int])
}

// MARK: - ListRouting
public protocol ListRouting: Routing {
    func launch(from window: UIWindow)
    func routeToSelection()
    var viewControllable: ViewControllable { get }
}

// MARK: - ListPresentable
public protocol ListPresentable: Presentable {
    var listener: ListPresentableListener? { get set }
}

public protocol ListPresentableListener: AnyObject {
    func didSelectItem(_ item: Int)
}

// MARK: - ListRIBBuildable
public protocol ListRIBBuildable: Buildable {
    func build() -> ListRouting
} 