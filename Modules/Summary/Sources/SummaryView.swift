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
    
    @Environment(\.navigationPath) private var navigationPath
    
    @State private var showSelection: Bool = false
    @State private var selectionState = SelectionSelection(value: "")
    
    var body: some View {
        VStack {
            Button("Pop Back") {
                navigationPath.pop()
            }
            
            Button("Pop to Root") {
                navigationPath.popToRoot()
            }
        }
        
        VStack(spacing: 30) {
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
            
            VStack(spacing: 12) {
                Button("Change Selection") {
                    
                    selectionState.value = selection.value
                    showSelection = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Done") {
                    navigationPath.pop()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .navigationTitle("Summary")
        .routeTo(route: SelectionRoute(selection: $selectionState), isActive: $showSelection, style: .sheet)
        .onChange(of: selectionState.value) { newValue in
            selection.value = newValue
        }
    }
}
