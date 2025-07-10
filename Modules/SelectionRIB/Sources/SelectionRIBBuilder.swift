import RIBs
import SummaryInterface
import Factory
import SwiftUI

// MARK: - BuilderProtocol
public protocol SelectionRIBBuildable: Buildable {
    func build() -> SelectionRIBRouting
}

// MARK: - Builder
public final class SelectionRIBBuilder: SelectionRIBBuildable {
    
    public init() {}
    
    public func build() -> SelectionRIBRouting {
        let viewController = SelectionRIBViewController()
        let interactor = SelectionRIBInteractor(presenter: viewController)
        let router = SelectionRIBRouter(
            interactor: interactor,
            viewController: viewController,
            summaryBuilder: Container.shared.summaryBuilder
        )
        return router
    }
}

// RootInteractor RootRouter
// RentAddOns <RIBS> RentReviewAndBook <Navigation> RentSummary // SwiftUI + new architecture
// RentReviewAndBook.route(swiftUI)

