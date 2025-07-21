import Factory
import RIBs
import UIKit
import SelectionRIB
import SelectionInterface
import SummaryInterface
import ListInterface
import SwiftUI

// Import the SelectionViewListener protocol
protocol SelectionViewListener: AnyObject {
    func didTapContinueToSummary(with selectionValue: String)
}

public final class ListRIBBuilder: ListRIBBuildable {
    public init() {}
    
    public func build() -> ListRouting {
        let viewController = ListViewController()
        let interactor = ListInteractor(presenter: viewController)
        viewController.listener = interactor
        let router = ListRouter(
            interactor: interactor,
            viewController: viewController
        )
        return router
    }
}

// MARK: - ListRouter
final class ListRouter: Router<ListInteractable>, ListRouting {
    var viewControllable: any RIBs.ViewControllable
    
    init(
        interactor: ListInteractable,
        viewController: ListViewControllable
    ) {
        self.viewControllable = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func routeToSelection(for item: Int) {
        let binding = Binding<SelectionSelection>(
            get: { SelectionSelection(value: "Element \(item)") },
            set: { _ in }
        )
        
        let builder = Container.shared.selectionBuilder.resolve((binding, interactor))
        let view = builder.buildView()
            .environment(\.presentationStyle, .push)
        
        let viewController = SwiftUIViewControllable(view)
        viewControllable.pushViewController(viewController)
    }
    
    func routeToSummary(with selectionValue: String) {
        let summaryBinding = Binding<SummarySelection>(
            get: { SummarySelection(value: selectionValue) },
            set: { _ in }
        )
        
        let builder = Container.shared.summaryBuilder.resolve((summaryBinding, interactor))
        let summaryView = builder.buildView()
            .environment(\.presentationStyle, .push)
        
        let summaryViewController = SwiftUIViewControllable(summaryView)
        viewControllable.pushViewController(summaryViewController)
    }
    
    func routeToRoot() {
        viewControllable.uiViewController.navigationController?.popToRootViewController(animated: true)
    }
    
    func pop() {
        viewControllable.uiViewController.navigationController?.popViewController(animated: true)
    }
}

// MARK: - ListInteractor
final class ListInteractor: PresentableInteractor<ListPresentable>, ListInteractable, ListPresentableListener {
    
    weak var router: ListRouting?
    
    override func didBecomeActive() {
        super.didBecomeActive()
        setupList()
    }
    
    private func setupList() {
        let items = Array(1...50)
        if let viewController = presenter as? ListViewControllable {
            viewController.showItems(items)
        }
    }
    
    func didSelectItem(_ item: Int) {
        router?.routeToSelection(for: item)
    }
}

extension ListInteractor: SelectionViewRIBListener {
    func didTapContinueToSummary(with selectionValue: String) {
        router?.routeToSummary(with: selectionValue)
    }
}

// MARK: - ListViewController
final class ListViewController: UIViewController, ListViewControllable, ListPresentable {
    
    weak var listener: ListPresentableListener?
    
    private let tableView = UITableView()
    private var items: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "List RIB"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showItems(_ items: [Int]) {
        self.items = items
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource & Delegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = "Element \(item)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        listener?.didSelectItem(item)
    }
}

// MARK: - SelectionListener Extension
extension ListInteractor: SelectionRIBListener {
    func selectionDidComplete() {}
}

// MARK: - SummaryViewRIBListener Extension
extension ListInteractor {
    func didTapPopBack() {
        router?.pop()
    }
    
    func didTapPopToRoot() {
        router?.routeToRoot()
    }
    
    func didTapDone() {
        router?.routeToRoot()
    }
}

