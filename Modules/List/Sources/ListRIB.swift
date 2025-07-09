import RIBs
import UIKit
import SelectionRIB
import ListInterface

public final class ListRIBBuilder: ListRIBBuildable {
    public init() {}
    
    public func build() -> ListRouting {
        let viewController = ListViewController()
        let interactor = ListInteractor(presenter: viewController)
        let router = ListRouter(interactor: interactor, viewController: viewController)
        return router
    }
}

// MARK: - ListRouter
final class ListRouter: Router<ListInteractable>, ListRouting {
    
    private let viewController: ListViewControllable
    var selectionBuilder: SelectionBuildable?
    
    init(interactor: ListInteractable, viewController: ListViewControllable) {
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func launch(from window: UIWindow) {
        window.rootViewController = viewControllable.uiViewController
        window.makeKeyAndVisible()
        
        interactable.activate()
        load()
    }
    
    func routeToSelection() {
        // TODO: Implement routing to selection
    }
    
    var viewControllable: ViewControllable {
        return viewController
    }
}

// MARK: - ListInteractor
final class ListInteractor: PresentableInteractor<ListPresentable>, ListInteractable {
    
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
        router?.routeToSelection()
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
        title = "List"
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
extension ListInteractor: SelectionListener {
    func selectionDidComplete() {
        // Handle selection completion if needed
    }
}

