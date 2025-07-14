import Foundation
import Factory
import UIKit
import SwiftUI
import RouterService
import RootRIB

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
    @Injected(\.router) var router: RouterService.Router
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Configure navigation bar appearance to fix safe area background color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
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
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        _ = router.handle(deepLink: url)
    }
}
