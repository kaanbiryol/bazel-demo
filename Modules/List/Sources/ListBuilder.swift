//
//  ListBuilder.swift
//  App
//
//  Created by Kaan Biryol on 12.02.24.
//

import Foundation
import SwiftUI
import NetworkingInterface
import Details

public struct ListBuilderView: View {
    
    let abc = ListModel()
    
    public init() {}
    
    public var body: some View {
        ListView(networkingService: Mock())
    }
    
}
