import RIBs
import SummaryInterface
import Factory
import SwiftUI

public protocol SelectionRouting: ViewableRouting {
    func routeToSummary(selectionBinding: Binding<SummarySelection>)
}

public protocol SelectionViewControllable: ViewControllable {
    func updateText(_ text: String)
}

final class SelectionRouter: RIBs.Router<SelectionInteractable>, SelectionRouting {
    
    var viewControllable: any RIBs.ViewControllable
    
    private let summaryBuilder: ParameterFactory<Binding<SummarySelection>, SummaryBuildable>
    
    init(
        interactor: SelectionInteractable,
        viewController: SelectionViewControllable,
        summaryBuilder: ParameterFactory<Binding<SummarySelection>, SummaryBuildable>
    ) {
        self.viewControllable = viewController
        self.summaryBuilder = summaryBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func routeToSummary(selectionBinding: Binding<SummarySelection>) {
        let summaryView = summaryBuilder(selectionBinding).buildView(fromRoute: nil)
        let summaryController = SwiftUIViewControllable(summaryView)
        viewControllable.pushViewController(summaryController)
        // TODO:  check if (push) UINavigationController / NavigationStack can work together
    }
}

final class SwiftUIViewControllable: ViewControllable {
    var uiViewController: UIViewController
    
    init(_ view: some View) {
        self.uiViewController = UIHostingController(rootView: view)
    }
}
