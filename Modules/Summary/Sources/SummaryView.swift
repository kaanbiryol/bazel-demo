import RouterService
import RIBs
import Foundation
import SwiftUI
import NetworkingInterface
import SummaryInterface
import SelectionInterface
import UIKit

struct SummaryView: View {
    
    @Binding var selection: SummarySelection
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSelection: Bool = false
    @State private var selectionState = SelectionSelection(value: "")
    
    var body: some View {
        VStack(spacing: 30) {
            // Display current selection
            VStack(spacing: 16) {
                Text("Your Selection")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if selection.value.isEmpty {
                    Text("No items selected")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                } else {
                    Text(selection.value)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                Button("Change Selection") {
                    // Set the current selection in the selection state
                    selectionState.value = selection.value
                    showSelection = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .navigationTitle("Summary")
        .routeTo(route: SelectionRoute(selection: $selectionState), isActive: $showSelection, style: .sheet)
        .onChange(of: selectionState.value) { newValue in
            // Update the summary selection when coming back from selection screen
            selection.value = newValue
        }
    }
}
