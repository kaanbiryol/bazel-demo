import Factory
import RIBs
import UIKit
import SelectionInterface
import SummaryInterface
import ListInterface
import SwiftUI

protocol SelectionViewListener: AnyObject {
    func didTapContinueToSummary(with selectionValue: String)
}

// MARK: - ListRIBBuilder
public final class ListRIBBuilder: ListRIBBuildable {
    public init() {}
    
    public func build() -> ListRouting {
        let viewController = ListViewController()
        let interactor = ListInteractor(presenter: viewController)
        viewController.listener = interactor
        let router = ListRouter(
            interactor: interactor,
            viewController: viewController,
            selectionBuilder: Container.shared.selectionBuilder,
            summaryBuilder: Container.shared.summaryBuilder
        )
        return router
    }
}

// MARK: - ListRouter
final class ListRouter: Router<ListInteractable>, ListRouting {
    var viewControllable: any RIBs.ViewControllable
    
    private let selectionBuilder: ParameterFactory<(Binding<SelectionValue>, SelectionViewRIBListener?), SelectionBuildable>
    private let summaryBuilder: ParameterFactory<(Binding<SummaryValue>, SummaryViewRIBListener?), SummaryBuildable>
    
    init(
        interactor: ListInteractable,
        viewController: ListViewControllable,
        selectionBuilder: ParameterFactory<(Binding<SelectionValue>, SelectionViewRIBListener?), SelectionBuildable>,
        summaryBuilder: ParameterFactory<(Binding<SummaryValue>, SummaryViewRIBListener?), SummaryBuildable>
    ) {
        self.viewControllable = viewController
        self.selectionBuilder = selectionBuilder
        self.summaryBuilder = summaryBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    // MARK: - Factory Methods
    
    private func makeSelectionViewController(for item: Int) -> SwiftUIViewControllable {
        let binding = Binding<SelectionValue>(
            get: { SelectionValue(value: "Element \(item)") },
            set: { _ in }
        )
        
        let builder = selectionBuilder.resolve((binding, interactor))
        let view = builder.buildView()
            .environment(\.presentationStyle, .push)
        
        return SwiftUIViewControllable(view)
    }
    
    private func makeSummaryViewController(with selectionValue: String) -> SwiftUIViewControllable {
        let summaryBinding = Binding<SummaryValue>(
            get: { SummaryValue(value: selectionValue) },
            set: { _ in }
        )
        
        let builder = summaryBuilder.resolve((summaryBinding, interactor))
        let summaryView = builder.buildView()
            .environment(\.presentationStyle, .push)
        
        return SwiftUIViewControllable(summaryView)
    }
    
    // MARK: - Routing Methods
    
    func routeToSelection(for item: Int) {
        let viewController = makeSelectionViewController(for: item)
        viewControllable.pushViewController(viewController)
    }
    
    func routeToSummary(with selectionValue: String) {
        let viewController = makeSummaryViewController(with: selectionValue)
        viewControllable.pushViewController(viewController)
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

// MARK: - SelectionViewRIBListener

extension ListInteractor {
    func didTapContinueToSummary(with selectionValue: String) {
        router?.routeToSummary(with: selectionValue)
    }
}

// MARK: - SummaryViewRIBListener

extension ListInteractor {
    func didTapPopBack() {
        router?.pop()
    }
    
    func didTapPopToRoot() {
        router?.routeToRoot()
    }
    
    func didTapDone(value: String) {
        print("Received value in RIBs: ", value)
        router?.routeToRoot()
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
