import RouterService
import RIBs
import Foundation
import SwiftUI
import NetworkingInterface
import SelectionInterface
import UIKit

struct SelectionView: View {
    
    @Binding var selection: SelectionSelection
    @Environment(\.dismiss) private var dismiss
    
    @State private var isActive: Bool = false
    @State private var name: String = "Selection"
    
    var body: some View {
        VStack(spacing: 20) {
            // Display current selection value
            VStack {
                Text("Current Selection:")
                    .font(.headline)
                Text(selection.value.isEmpty ? "None" : selection.value)
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Selection buttons
            HStack(spacing: 15) {
                Button("Option A") {
                    selection.value = "Option A"
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Option B") {
                    selection.value = "Option B"
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Option C") {
                    selection.value = "Option C"
                    isActive = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            // Clear selection button
            Button("Clear") {
                selection.value = ""
                dismiss()
            }
            .buttonStyle(.bordered)
            .foregroundColor(.red)
        }
        .padding()
        .navigationTitle("Selection")
        .routeTo(route: SelectionTestRoute(), isActive: $isActive, style: .push)
    }
}

public class SelectionTestBuilder: Builder2 {
    
    public init() {
         
    }
    
    public func buildView(fromRoute route: Route?) -> AnyView {
        return AnyView(
            VStack {
                Text("Selection Test View")
                    .font(.title)
                    .padding()
                Text("You selected Option C")
                    .font(.body)
                    .padding()
            }
        )
    }
}

public struct SelectionTestRoute: Route {
    public static var identifier: String = "selection_test_route"
    
    public init() {
    }
    
    public func getBuilder() -> any Builder2 {
        return SelectionTestBuilder()
    }
} 