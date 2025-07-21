import RIBs
import UIKit
import Factory
import ListInterface
import SwiftUI
import RootType

// MARK: - RootViewControllable
protocol RootViewControllable: ViewControllable {
    func embedViewController(_ viewController: ViewControllable)
    func unembedViewController(_ viewController: ViewControllable)
}

// MARK: - RootRouting
public protocol RootRouting: Routing {
    func launch(from window: UIWindow)
    func routeToList()
}

// MARK: - RootRouter
final class RootRouter: Router<RootInteractable>, RootRouting {
    
    private let viewControllable: RootViewControllable
    private var listRouter: ListRouting?
    
    @Injected(\.listBuilder) var listBuilder: ListBuildable
    @Injected(\.listRIBBuilder) var listRIBBuilder: ListRIBBuildable
    @Injected(\.rootType) var rootType: RootType
    
    init(interactor: RootInteractable, viewController: RootViewControllable) {
        self.viewControllable = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func launch(from window: UIWindow) {
        window.rootViewController = viewControllable.uiViewController
        window.makeKeyAndVisible()
        
        interactable.activate()
        load()
    }
    
    func routeToList() {
        switch rootType {
        case .rib:
            let listRouter = listRIBBuilder.build()
            self.listRouter = listRouter
            
            let navigationController = UINavigationController(rootViewController: listRouter.viewControllable.uiViewController)
            let navigationViewControllable = NavigationViewControllable(navigationController: navigationController)
            
            attachChild(listRouter, attachingType: .embedded)
            viewControllable.embedViewController(navigationViewControllable)
            
        case .swiftUI:
            let listView = listBuilder.buildView()
            let summaryController = SwiftUIViewControllable(listView)
            viewControllable.embedViewController(summaryController)
        }
    }
}

final class SwiftUIViewControllable: ViewControllable {
    var uiViewController: UIViewController

    init(_ view: some View) {
        self.uiViewController = UIHostingController(rootView: view)
    }
}


final class NavigationViewControllable: ViewControllable {
    let uiViewController: UIViewController
    
    init(navigationController: UINavigationController) {
        self.uiViewController = navigationController
    }
}
