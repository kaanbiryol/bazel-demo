import Foundation
import UIKit
import SwiftUI
import RIBs
import SummaryInterface

protocol SelectionRIBInteractable: Interactable {
    var router: SelectionRIBRouting? { get set }
    var listener: SelectionRIBListener? { get set }
    
    func didSelectNumber(_ number: Int)
    func didTapNext()
}

final class SelectionRIBInteractor: Interactor, SelectionRIBInteractable {
    weak var router: SelectionRIBRouting?
    weak var listener: SelectionRIBListener?
    
    private let presenter: SelectionRIBPresentable
    
    private let selectionBinding: Binding<SummarySelection> = Binding.constant(SummarySelection(value: ""))
    
    init(presenter: SelectionRIBPresentable) {
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
    
    func didSelectNumber(_ number: Int) {
        presenter.updateWithSelection(number)
    }
    
    func didTapNext() {
        router?.routeToSummary(selectionBinding: selectionBinding)
    }
}
