import Foundation
import UIKit
import SwiftUI
import RIBs
import DetailsInterface

protocol SelectionInteractable: Interactable {
    var router: SelectionRouting? { get set }
    var listener: SelectionTextListener? { get set }
    
    func didSelectNumber(_ number: Int)
}

final class SelectionTextInteractor: Interactor, SelectionInteractable {
    weak var router: SelectionRouting?
    weak var listener: SelectionTextListener?
    
    private let presenter: SelectionPresentable
    
    init(presenter: SelectionPresentable) {
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
}
