import RouterService
import RIBs
import Foundation
import SwiftUI
import NetworkingInterface
import SelectionInterface
import SummaryInterface
import UIKit


struct SelectionView: View {
    
    @Binding var selection: SelectionSelection
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationStyle) private var presentationStyle
    
    @State private var selectedOptions: Set<String> = []
    @State private var showSummary: Bool = false
    @State private var summarySelection = SummarySelection(value: "")
    
    var body: some View {
        VStack(spacing: 30) {
            Text(selectedOptions.isEmpty ? "Select options below" : "\(selectedOptions.count) selected")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(height: 20)
            
            VStack(spacing: 12) {
                SelectionRow(title: "Option A", isSelected: selectedOptions.contains("Option A")) {
                    toggleSelection("Option A")
                }
                
                SelectionRow(title: "Option B", isSelected: selectedOptions.contains("Option B")) {
                    toggleSelection("Option B")
                }
                
                SelectionRow(title: "Option C", isSelected: selectedOptions.contains("Option C")) {
                    toggleSelection("Option C")
                }
            }
            
            Button(continueButtonTitle) {
                handleContinueAction()
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedOptions.isEmpty)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Selection")
        .routeTo(route: SummaryRoute(selection: $summarySelection), isActive: $showSummary, style: .push)
        .onAppear {
            loadCurrentSelections()
        }
    }
    
    private var continueButtonTitle: String {
        return presentationStyle == .sheet ? "Done" : "Continue to Summary"
    }
    
    private func handleContinueAction() {
        if presentationStyle == .sheet {
            // We're presented as a sheet, just dismiss
            dismiss()
        } else {
            // We're pushed, navigate to Summary
            goToSummary()
        }
    }
    
    private func loadCurrentSelections() {
        if !selection.value.isEmpty {
            let options = selection.value.components(separatedBy: ", ")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            selectedOptions = Set(options)
        }
    }
    
    private func toggleSelection(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
        selection.value = selectedOptions.sorted().joined(separator: ", ")
    }
    
    private func goToSummary() {
        let summaryText = selectedOptions.sorted().joined(separator: ", ")
        summarySelection.value = summaryText
        showSummary = true
    }
}

struct SelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
