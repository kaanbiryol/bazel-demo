import Foundation
import UIKit
import SwiftUI
import RIBs
import DetailsInterface

// MARK: - BuilderProtocol
public protocol SimpleTextBuildable: Buildable {
    func build() -> SimpleTextRouting
}

// MARK: - Builder
public final class SimpleTextBuilder: SimpleTextBuildable {
    public init() {}
    
    public func build() -> SimpleTextRouting {
        let viewController = SimpleTextViewController()
        let interactor = SimpleTextInteractor(presenter: viewController)
        let router = SimpleTextRouter(interactor: interactor, viewController: viewController)
        return router
    }
}

// MARK: - Routing
public protocol SimpleTextRouting: ViewableRouting {
    func routeToSomewhere()
}

// MARK: - ViewControllable
public protocol SimpleTextViewControllable: ViewControllable {
    func updateText(_ text: String)
}

// MARK: - Interactable
protocol SimpleTextInteractable: Interactable {
    var router: SimpleTextRouting? { get set }
    var listener: SimpleTextListener? { get set }
    
    func didButtonTap()
    func didSelectNumber(_ number: Int)
}

// MARK: - Listener
public protocol SimpleTextListener: AnyObject {
    // Define listener methods here if needed
}

// MARK: - Interactor
final class SimpleTextInteractor: Interactor, SimpleTextInteractable {
    weak var router: SimpleTextRouting?
    weak var listener: SimpleTextListener?
    
    private let presenter: SimpleTextPresentable
    
    init(presenter: SimpleTextPresentable) {
        self.presenter = presenter
        super.init()
        
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - SimpleTextInteractable
    
    func didButtonTap() {
        presenter.updateText("Button tapped! Handled by Interactor")
        
        router?.routeToSomewhere()
    }
    
    func didSelectNumber(_ number: Int) {
        // Process the number selection
        print("Number \(number) selected")
        
        // Update the presenter with the selection
        presenter.updateWithSelection(number)
    }
}

// MARK: - Presentable
protocol SimpleTextPresentable: AnyObject {
    func updateText(_ text: String)
    func updateWithSelection(_ number: Int)
    
    var listener: SimpleTextInteractable? { get set }
}

// MARK: - Router
final class SimpleTextRouter: RIBs.Router<SimpleTextInteractable>, SimpleTextRouting {
    var viewControllable: any RIBs.ViewControllable
    
    init(interactor: SimpleTextInteractable, viewController: SimpleTextViewControllable) {
        self.viewControllable = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func routeToSomewhere() {
        // Implementation for routing to another RIB would go here
        print("SimpleTextRouter: routeToSomewhere called")
    }
} 
