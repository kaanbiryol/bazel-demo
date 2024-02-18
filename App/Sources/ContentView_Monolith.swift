//
//  ContentView.swift
//  App
//
//  Created by Kaan Biryol on 01.11.23.
//

import SwiftUI
import Monolith

struct ContentView: View {
    var body: some View {
        ListView(networkingService: NetworkingImpl())
    }
}

#Preview {
    ContentView()
}
