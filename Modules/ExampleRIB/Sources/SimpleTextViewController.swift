import UIKit
import SwiftUI
import RIBs
import DetailsInterface
import Details

// MARK: - ViewController
final class SimpleTextViewController: UIViewController, SimpleTextPresentable, SimpleTextViewControllable {
    
    private let label = UILabel()
    private let actionButton = UIButton(type: .system)
    private let detailsContainer = UIView()
    private let numbersContainer = UIView()
    private let mainStackView = UIStackView()
    
    weak var listener: SimpleTextInteractable?
    
    private var selection: RentDetailsSelection = RentDetailsSelection(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        embedDetailsView()
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
        
        // Configure action button
        actionButton.setTitle("Trigger Action", for: .normal)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        // Configure numbers container
        numbersContainer.backgroundColor = .systemBackground
        
        // Add three numbered buttons to the container
        let numbersStackView = UIStackView()
        numbersStackView.axis = .horizontal
        numbersStackView.distribution = .fillEqually
        numbersStackView.spacing = 10
        numbersStackView.translatesAutoresizingMaskIntoConstraints = false
        numbersContainer.addSubview(numbersStackView)
        
        // Create and add three buttons
        for number in 1...3 {
            let button = UIButton(type: .system)
            button.setTitle("\(number)", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 8
            button.tag = number
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
            numbersStackView.addArrangedSubview(button)
        }
        
        // Set constraints for the numbers stack view inside numbersContainer
        NSLayoutConstraint.activate([
            numbersStackView.topAnchor.constraint(equalTo: numbersContainer.topAnchor, constant: 8),
            numbersStackView.leadingAnchor.constraint(equalTo: numbersContainer.leadingAnchor, constant: 8),
            numbersStackView.trailingAnchor.constraint(equalTo: numbersContainer.trailingAnchor, constant: -8),
            numbersStackView.bottomAnchor.constraint(equalTo: numbersContainer.bottomAnchor, constant: -8),
            numbersContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Add all components to the main stack view in order
        mainStackView.addArrangedSubview(detailsContainer)
        mainStackView.addArrangedSubview(label)
        mainStackView.addArrangedSubview(actionButton)
        mainStackView.addArrangedSubview(numbersContainer)
        
        // Add padding to the stack view using constraints
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func embedDetailsView() {
        let selectionBinding = Binding<RentDetailsSelection>(
            get: { self.selection },
            set: { newValue in
                self.selection = newValue
                self.label.text = "Selected: \(newValue.value)"
            }
        )
        
        let detailsBuilder = RentDetailsBuilder(selectionBinding: selectionBinding)
        if let detailsView = detailsBuilder.buildView(fromRoute: nil) {
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
    }
    
    @objc private func actionButtonTapped() {
        listener?.didButtonTap()
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        let number = sender.tag
        listener?.didSelectNumber(number)
    }
    
    // MARK: - SimpleTextPresentable
    func updateText(_ text: String) {
        label.text = text
    }
    
    func updateWithSelection(_ number: Int) {
        label.text = "Selected: \(number)"
    }
} 
