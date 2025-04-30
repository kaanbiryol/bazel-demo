//
//  AppApp.swift
//  App
//
//  Created by Kaan Biryol on 01.11.23.
//

import SwiftUI
import Collections
import NetworkingInterface
import ListInterface
import List
import DetailsInterface
import Details
import RouterService
import Networking
import Factory
import RIBs

@main
struct Root: App {
     
    @Injected(\.listBuilder) private var listBuilder: ListBuildable
    
    init() {}
    
    var body: some Scene {
        WindowGroup {
            listBuilder.buildView(fromRoute: ListRoute())
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


// MARK: - WIP RIBS

protocol RootInteractable: Interactable {
    var router: RootRouting? { get set }
}

protocol RootListener: AnyObject {
    
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set  }
}

protocol RootPresentableListener: AnyObject {
    func didNavigateBack()
}

@Observable class RootInteractor: Interactor, RootInteractable {
    
    weak var router: RootRouting?
    
    @ObservationIgnored @State private var routeToList: Bool = true
    
    public override init() {
        super.init()
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.routeToList(binding: $routeToList)
        
    }
}

extension RootInteractor: RootPresentableListener {
    func didNavigateBack() {
        
    }
}

protocol RootViewControllable: ViewControllable {
    func embedQuickFilter(_ viewController: ViewControllable)
    func unembedQuickFilter(_ viewController: ViewControllable)
}

protocol RootRouting: Routing {
    func routeToList(binding: Binding<Bool>)
}

