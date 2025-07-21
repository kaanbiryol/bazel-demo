import RIBs
import UIKit
import SelectionInterface
import SummaryInterface

// MARK: - ListInteractable
public protocol ListInteractable: Interactable, SelectionViewRIBListener, SummaryViewRIBListener {
    var router: ListRouting? { get set }
    func didSelectItem(_ item: Int)
}

// MARK: - ListViewControllable
public protocol ListViewControllable: ViewControllable {
    func showItems(_ items: [Int])
}

// MARK: - ListRouting
public protocol ListRouting: Routing {
    var viewControllable: ViewControllable { get }
    func routeToSelection(for item: Int)
    func routeToSummary(with selectionValue: String)
    func routeToRoot()
    func pop()
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
