import RIBs

// MARK: - RootInteractable
protocol RootInteractable: Interactable {
    var router: RootRouting? { get set }
}

// MARK: - RootPresentable
protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootPresentableListener: AnyObject {}

// MARK: - RootInteractor
final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable {
    
    weak var router: RootRouting?
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.routeToList()
    }
}
