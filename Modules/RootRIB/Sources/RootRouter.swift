import RIBs
import UIKit
import Factory
import ListInterface
import SwiftUI

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
    
    init(interactor: RootInteractable, viewController: RootViewControllable) {
        self.viewControllable = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func launch(from window: UIWindow) {
        // Wrap in navigation controller to match SwiftUI NavigationStack behavior
        let navigationController = UINavigationController(rootViewController: viewControllable.uiViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        interactable.activate()
        load()
    }
    
    func routeToList() {
//        let listRouter = listRIBBuilder.build()
//        self.listRouter = listRouter
//        
//        attachChild(listRouter, attachingType: .embedded)
//        viewController.embedViewController(listRouter.viewControllable)
        
        let listView = listBuilder.buildView(fromRoute: nil)
        let summaryController = SwiftUIViewControllable(listView)
        viewControllable.pushViewController(summaryController)
    }
}

final class SwiftUIViewControllable: ViewControllable {
    var uiViewController: UIViewController

    init(_ view: some View) {
        self.uiViewController = UIHostingController(rootView: view)
    }
}
