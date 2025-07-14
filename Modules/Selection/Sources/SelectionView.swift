import RouterService
import RIBs
import Foundation
import SwiftUI
import NetworkingInterface
import SelectionInterface
import SummaryInterface
import UIKit

struct SelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationStyle) private var presentationStyle
    @Environment(\.navigationPath) private var navigationPath
    
    @Binding var selection: SelectionSelection
    
    @State private var selectedOptions: Set<String> = []
    @State private var summarySelection = SummarySelection(value: "")
    
    var body: some View {
        VStack(spacing: 12) {
            SelectionRow(title: "A", isSelected: selectedOptions.contains("A")) {
                toggleSelection("A")
            }
            
            SelectionRow(title: "B", isSelected: selectedOptions.contains("B")) {
                toggleSelection("B")
            }
            
            SelectionRow(title: "C", isSelected: selectedOptions.contains("C")) {
                toggleSelection("C")
            }
            
            Spacer().frame(height: 8)
            
            Button(continueButtonTitle) {
                if presentationStyle == .sheet {
                    dismiss()
                } else {
                    goToSummary()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Selection")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCurrentSelections()
        }
        .onChange(of: selection.value) { newValue in
            loadCurrentSelections()
        }
    }
    
    private var continueButtonTitle: String {
        return presentationStyle == .sheet ? "Done" : "Continue to Summary"
    }
    
    private func loadCurrentSelections() {
        if !selection.value.isEmpty {
            let options = selection.value.components(separatedBy: ", ")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            selectedOptions = Set(options)
        } else {
            selectedOptions = []
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
        navigationPath.push(SummaryRoute(selection: $summarySelection))
    }
    
    private struct SelectionRow: View {
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
}
