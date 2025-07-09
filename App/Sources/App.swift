import SwiftUI
import Collections
import NetworkingInterface
import ListInterface
import List
import SummaryInterface
import Summary
import RouterService
import Networking
import Factory
import RIBs
import UIKit
import RootRIB

// MARK: - Architecture Choice
enum RootType {
    case rib
    case swiftUI
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    @Injected(\.rootRIBBuilder) var rootRIBBuilder: RootRIBBuildable
    
    @Injected(\.rootType) var rootType: RootType
    
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        switch rootType {
        case .swiftUI:
            let rootView = RootSwiftUI()
            let hostingController = UIHostingController(rootView: rootView)
            window.rootViewController = hostingController
            window.makeKeyAndVisible()
        case .rib:
            let router = rootRIBBuilder.build()
            router.launch(from: window)
        }
    }
}

@main
struct Root: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // Empty placeholder - SceneDelegate handles the UI setup
            // (either SwiftUI or RIBs based on the useSwiftUI flag)
            Color.clear
                .ignoresSafeArea()
        }
    }
}

private class CollectionsTest {
    func deque() {
        var deque: Deque<String> = ["Ted", "Rebecca"]
        deque.prepend("Keeley")
        deque.append("Nathan")
        print(deque) // ["Keeley", "Ted", "Rebecca", "Nathan"]
    }
}
