import RIBs
import SummaryInterface
import Factory
import SwiftUI

public protocol SelectionRIBRouting: ViewableRouting {
    func routeToSummary(selectionBinding: Binding<SummarySelection>)
}

public protocol SelectionRIBViewControllable: ViewControllable {
    func updateText(_ text: String)
}

final class SelectionRIBRouter: RIBs.Router<SelectionRIBInteractable>, SelectionRIBRouting {
    
    var viewControllable: any RIBs.ViewControllable
    
    private let summaryBuilder: ParameterFactory<Binding<SummarySelection>, SummaryBuildable>
    
    init(
        interactor: SelectionRIBInteractable,
        viewController: SelectionRIBViewControllable,
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
