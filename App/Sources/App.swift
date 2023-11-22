//
//  AppApp.swift
//  App
//
//  Created by Kaan Biryol on 01.11.23.
//

import SwiftUI
import Collections

@main
struct AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
