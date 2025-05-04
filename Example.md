import UIKit
import SwiftUI
import RIBs
import Combine

// MARK: - Data Flow Example RIB

// State shared between SwiftUI and RIBs
final class CounterState: ObservableObject {
    @Published var count: Int = 0
    @Published var message: String = "Welcome to Counter"
    @Published var isLoading: Bool = false
    
    // Callbacks for events from SwiftUI
    var onIncrementTapped: (() -> Void)?
    var onDecrementTapped: (() -> Void)?
    var onResetTapped: (() -> Void)?
    var onMessageUpdateRequested: ((String) -> Void)?
}

// SwiftUI View that will be embedded
struct CounterView: View {
    @ObservedObject var state: CounterState
    
    var body: some View {
        VStack(spacing: 20) {
            Text(state.message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Count: \(state.count)")
                .font(.system(size: 40, weight: .bold))
            
            HStack(spacing: 20) {
                Button("-") {
                    state.onDecrementTapped?()
                }
                .font(.system(size: 30))
                .frame(width: 80, height: 50)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("+") {
                    state.onIncrementTapped?()
                }
                .font(.system(size: 30))
                .frame(width: 80, height: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button("Reset") {
                state.onResetTapped?()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            TextField("Enter new message", text: Binding(
                get: { self.state.message },
                set: { newValue in
                    // Don't update state directly, send to interactor
                    self.state.onMessageUpdateRequested?(newValue)
                }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if state.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding()
    }
}

// MARK: - RIB Protocols

protocol CounterInteractable: Interactable {
    var router: CounterRouting? { get set }
    var listener: CounterListener? { get set }
}

protocol CounterPresentable: Presentable {
    var listener: CounterPresentableListener? { get set }
}

protocol CounterListener: AnyObject {
    // Methods for parent to listen to events
}

protocol CounterPresentableListener: AnyObject {
    // View controller to interactor communication
}

protocol CounterRouting: ViewableRouting {
    // Router methods
}

// MARK: - View Controller

final class CounterViewController: UIViewController, CounterPresentable {
    weak var listener: CounterPresentableListener?
    
    private let state: CounterState
    private var hostingController: UIHostingController<CounterView>?
    
    init(state: CounterState) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle()
        setupSwiftUIView()
    }
    
    private func setupTitle() {
        title = "Counter Example"
    }
    
    private func setupSwiftUIView() {
        // Create SwiftUI view
        let counterView = CounterView(state: state)
        
        // Create and set up hosting controller
        let hostingController = UIHostingController(rootView: counterView)
        self.hostingController = hostingController
        
        // Add as child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Configure constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}

// MARK: - Interactor

final class CounterInteractor: Interactor, CounterInteractable, CounterPresentableListener {
    weak var router: CounterRouting?
    weak var listener: CounterListener?
    
    // State shared with SwiftUI
    private let state: CounterState
    private var cancellables = Set<AnyCancellable>()
    
    init(state: CounterState) {
        self.state = state
        super.init()
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        setupCallbacks()
        setupSubscriptions()
    }
    
    override func willResignActive() {
        super.willResignActive()
        cancellables.removeAll()
    }
    
    // Set up callbacks to handle events from SwiftUI
    private func setupCallbacks() {
        state.onIncrementTapped = { [weak self] in
            self?.incrementCounter()
        }
        
        state.onDecrementTapped = { [weak self] in
            self?.decrementCounter()
        }
        
        state.onResetTapped = { [weak self] in
            self?.resetCounter()
        }
        
        state.onMessageUpdateRequested = { [weak self] newMessage in
            self?.updateMessage(newMessage)
        }
    }
    
    // Set up subscriptions to observe state changes
    private func setupSubscriptions() {
        // Example of subscribing to state changes if needed
        state.$count
            .sink { [weak self] newCount in
                // Handle count changes if needed
                if newCount % 10 == 0 && newCount > 0 {
                    self?.handleMilestone(count: newCount)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Business Logic
    
    private func incrementCounter() {
        state.count += 1
        print("Incremented counter to: \(state.count)")
    }
    
    private func decrementCounter() {
        state.count -= 1
        print("Decremented counter to: \(state.count)")
    }
    
    private func resetCounter() {
        // Simulate loading state
        state.isLoading = true
        
        // Artificial delay to show loading state
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.state.count = 0
            self?.state.message = "Counter has been reset"
            self?.state.isLoading = false
        }
    }
    
    private func updateMessage(_ newMessage: String) {
        // Add business logic or validation here
        if !newMessage.isEmpty {
            state.message = newMessage
            print("Message updated to: \(newMessage)")
        }
    }
    
    private func handleMilestone(count: Int) {
        state.message = "Congratulations! You reached \(count)!"
    }
}

// MARK: - Router

final class CounterRouter: ViewableRouter<CounterInteractable, CounterPresentable>, CounterRouting {
    override init(interactor: CounterInteractable, viewController: CounterPresentable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - Builder

final class CounterBuilder {
    func build() -> CounterRouting {
        // Create shared state
        let state = CounterState()
        
        // Create components
        let viewController = CounterViewController(state: state)
        let interactor = CounterInteractor(state: state)
        
        // Connect components
        return CounterRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}

// MARK: - Usage Example

// To use this RIB:
// let counterRouter = CounterBuilder().build()
// attachChild(counterRouter)
// present(counterRouter.viewControllable.uiViewController, animated: true)