import RIBs
import SummaryInterface
import Factory
import SwiftUI

// MARK: - BuilderProtocol
public protocol SelectionBuildable: Buildable {
    func build() -> SelectionRouting
}

// MARK: - Builder
public final class SelectionRIBBuilder: SelectionBuildable {
    
    public init() {}
    
    public func build() -> SelectionRouting {
        let viewController = SelectionViewController()
        let interactor = SelectionInteractor(presenter: viewController)
        let router = SelectionRouter(
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

