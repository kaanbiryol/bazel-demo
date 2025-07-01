import RIBs

public protocol SelectionRouting: ViewableRouting {
    func routeToSomewhere()
}

public protocol SelectionViewControllable: ViewControllable {
    func updateText(_ text: String)
}

final class SelectionRouter: RIBs.Router<SelectionInteractable>, SelectionRouting {
    var viewControllable: any RIBs.ViewControllable
    
    init(interactor: SelectionInteractable, viewController: SelectionViewControllable) {
        self.viewControllable = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func routeToSomewhere() {
        print("routeToSomewhere called")
    }
}
