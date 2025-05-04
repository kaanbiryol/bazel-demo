import RouterService
import RIBs
import Foundation
import SwiftUI
import NetworkingInterface
import DetailsInterface

public class RentDetailsBuilder: RentDetailsBuildable {
//    @Injected(\.networkingService) private var networkingService
//    @Injected(\.router) private var router
    
    private var selectionBinding: Binding<RentDetailsSelection>
    
    public init(selectionBinding: Binding<RentDetailsSelection>) {
        self.selectionBinding = selectionBinding
    }
    
    public func buildView(fromRoute route: Route?) -> AnyView? {
        // Create the interactor
        
        // Return the ListView wrapped in AnyView
        return AnyView(
            RentDetailsView(selection: selectionBinding)
        )
    }
}

private struct RentDetailsView: View {
    
    @Binding var selection: RentDetailsSelection
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button("1") {
                selection = RentDetailsSelection(value: "1")
                dismiss()
            }
            Button("2") {
                selection = RentDetailsSelection(value: "2")
                dismiss()
            }
            Button("3") {
                selection = RentDetailsSelection(value: "3")
                dismiss()
            }
        }
    }
    
}

// MARK: WIP RIBS

//public protocol DetailsInteractorProtocol {
//    var networkingService: NetworkingService { get }
//    var routerService: RouterServiceProtocol { get }
//    var items: [Int] { get }
//    var title: String { get }
//    func viewDidLoad()
//}

//@Observable class DetailsInteractor: Interactor, DetailsInteractable {
//    
//    weak var router: (any DetailsRouting)?
//    
//    override func didBecomeActive() {
//        super.didBecomeActive()
//    }
//}
//
//protocol DetailsInteractable: Interactable {
//    var router: DetailsRouting? { get set }
//}
//
//protocol DetailsViewControllable: ViewControllable {
//    func embedQuickFilter(_ viewController: ViewControllable)
//    func unembedQuickFilter(_ viewController: ViewControllable)
//}
//
//protocol DetailsRouting: Routing {
//    func routeToRentHomeBottomSheet(binding: Binding<Bool>)
//    func cleanupViews()
//    func cleanupPresentedChild()
//}

//final class DetailsRouter: Router<DetailsInteractable>, DetailsRouting {
//    
//    let routerService: RouterServiceProtocol
////    var vc: DetailsViewControllable!
//
//    init(interactor: DetailsInteractable, routerService: RouterServiceProtocol) {
//        self.routerService = routerService
//        super.init(interactor: interactor)
//        interactor.router = self
//    }
//    
//    
//    func routeToRentHomeBottomSheet(binding: Binding<Bool>) {
//        // get builder
//        
////        routerService.navigateTo(route: DetailsRoute(element: 0), isActive: binding, style: .fullScreenCover)
////        attachChild(alert, attachingType: .modal)
//        
//////        viewController.presentViewController(alert.viewControllable)
////
////        currentPresentedChild = alert
//    }
//    
//    func cleanupViews() {
//        
//    }
//    
//    func cleanupPresentedChild() {
//        
//    }
//}
