import UIKit
import SwiftUI
import RIBs
import SummaryInterface
import Summary

public protocol SelectionListener: AnyObject {}

protocol SelectionPresentable: AnyObject {
    func updateText(_ text: String)
    func updateWithSelection(_ number: Int)
    
    var listener: SelectionInteractable? { get set }
}

final class SelectionViewController: UIViewController, SelectionPresentable, SelectionViewControllable {
    
    private let label = UILabel()
    private let detailsContainer = UIView()
    private let selectionContainer = UIView()
    private let nextButton = UIButton(type: .system)
    private let mainStackView = UIStackView()
    
    var listener: SelectionInteractable?
    
    private var selection: SummarySelection = SummarySelection(value: "")
    private var selectedIndex: Int = 1 // Default to first option
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        embedDetailsView()
        
        updateWithSelection(selectedIndex)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Simple Text RIB"
        
        // Configure main stack view
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        // Configure container for DetailsView
        detailsContainer.backgroundColor = .systemGray6
        detailsContainer.layer.cornerRadius = 8
        detailsContainer.translatesAutoresizingMaskIntoConstraints = false
        // Set height constraint for details container
        let detailsHeightConstraint = detailsContainer.heightAnchor.constraint(equalToConstant: 150)
        detailsHeightConstraint.isActive = true
        
        // Configure main label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.text = "KAAN"
        
        selectionContainer.backgroundColor = .systemBackground
        
        // Add segmented control as radio button alternative
        let segmentedControl = UISegmentedControl(items: ["Option 1", "Option 2", "Option 3"])
        segmentedControl.selectedSegmentIndex = 0 // Default selection
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        selectionContainer.addSubview(segmentedControl)
        
        // Set constraints for the segmented control inside selectionContainer
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: selectionContainer.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: selectionContainer.centerYAnchor),
            segmentedControl.leadingAnchor.constraint(greaterThanOrEqualTo: selectionContainer.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(lessThanOrEqualTo: selectionContainer.trailingAnchor, constant: -16),
            selectionContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Configure Next button
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set height constraint for Next button
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add all components to the main stack view in order
        mainStackView.addArrangedSubview(detailsContainer)
        mainStackView.addArrangedSubview(label)
        mainStackView.addArrangedSubview(selectionContainer)
        
        // Add some spacing before the Next button
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        mainStackView.addArrangedSubview(spacerView)
        
        mainStackView.addArrangedSubview(nextButton)
        
        // Add padding to the stack view using constraints
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func embedDetailsView() {
        let selectionBinding = Binding<SummarySelection>(
            get: { self.selection },
            set: { newValue in
                self.selection = newValue
                self.label.text = "Selected: \(newValue.value)"
            }
        )
        
        let detailsBuilder = SummaryBuilder(selectionBinding: selectionBinding)
        let detailsView = detailsBuilder.buildView(fromRoute: nil)
        let hostingController = UIHostingController(rootView: detailsView)
        addChild(hostingController)
        detailsContainer.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: detailsContainer.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex + 1
        updateWithSelection(selectedIndex)
    }
    
    @objc private func nextButtonTapped() {
        listener?.didTapNext()
    }
    
    // MARK: - SimpleTextPresentable
    func updateText(_ text: String) {
        label.text = text
    }
    
    func updateWithSelection(_ number: Int) {
        label.text = "Selected: \(number)"
    }
}
