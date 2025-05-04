import Foundation
import SwiftUI
import NetworkingInterface
import DetailsInterface
import RouterService
import Factory
import UIKit
import RIBs
import Combine
import OrderInterface
import HomeInterface

//protocol ListInteractable: Interactable {
//    var router: ListRouting? { get set }
//}
//
//protocol ListViewControllable: ViewControllable {
//    func embedQuickFilter(_ viewController: ViewControllable)
//    func unembedQuickFilter(_ viewController: ViewControllable)
//}
//
//protocol ListRouting: Routing {
//    func routeToRentHomeBottomSheet(binding: Binding<Bool>)
//    func cleanupViews()
//    func cleanupPresentedChild()
//}

//final class ListRouter: Router<ListInteractable>, ListRouting {
//    
//    let routerService: RouterServiceProtocol
//    
//    init(interactor: ListInteractable, routerService: RouterServiceProtocol) {
//        self.routerService = routerService
//        super.init(interactor: interactor)
//        interactor.router = self
//    }
//    
//    func routeToRentHomeBottomSheet(binding: Binding<Bool>) {
//        // get builder
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
//
//@Observable public class ListInteractor: Interactor, ListInteractable {
//    @ObservationIgnored public let networkingService: NetworkingService
//    @ObservationIgnored public let routerService: RouterServiceProtocol
//    
//    public private(set) var items: [Int] = []
//    public private(set) var title: String = ""
//    
//    var selectemItem: Int?
//    
//    weak var router: ListRouting?
//    
//    public init(networkingService: NetworkingService, routerService: RouterServiceProtocol) {
//        self.networkingService = networkingService
//        self.routerService = routerService
//    }
//    
//    public override func didBecomeActive() {
//        super.didBecomeActive()
//        fetchData()
//    }
//    
//    private func fetchData() {
//        title = networkingService.fetchTitle()
//        items = Array(1...100)
////        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
////            self.selectemItem = 1
////        })
//    }
//}

// Mock for preview
public class Mock: NetworkingService {
    public init() {}
    
    public func fetchTitle() -> String {
        return "List Items"
    }
    
    public func fetchDetails() -> String {
        return "Details"
    }
}

#Preview {
    // For the preview, we need a mock RouterService as well
//    let store = Store()
//    store.register({ Mock() }, forMetaType: NetworkingService.self)
//    let routerService = RouterService(store: store)
//    
//    return ListView(networkingService: Mock(), routerService: routerService)
}
