import RouterService
import RIBs
import Foundation
import SwiftUI
import NetworkingInterface
import SummaryInterface
import SelectionInterface
import UIKit
import Factory
import RootType

struct SummaryView: View {
    
    @Binding var selection: SummaryValue
    @Environment(\.dismiss) private var dismiss
    @Environment(\.navigationPath) private var navigationPath
    
    @State private var showSelection: Bool = false
    @State private var selectionState = SelectionValue(value: "")
    
    @Injected(\.rootType) var rootType: RootType
    
    private weak var listener: SummaryViewRIBListener?
    
    init(selection: Binding<SummaryValue>, listener: SummaryViewRIBListener? = nil) {
        self._selection = selection
        self.listener = listener
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                Button("Pop Back") {
                    popBack()
                }
                .buttonStyle(.bordered)
                
                Button("Pop to Root") {
                    popToRoot()
                }
                .buttonStyle(.bordered)
            }
            
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
            
            Spacer()
            
            Button("Change Selection") {
                selectionState.value = selection.value
                showSelection = true
            }
            .buttonStyle(.borderedProminent)
            
            Button("Done") {
                handleDone()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .routeTo(route: SelectionRoute(selection: $selectionState), isActive: $showSelection, style: .sheet)
        .onChange(of: selectionState.value) { newValue in
            selection.value = newValue
        }
    }
    
    private func popBack() {
        switch rootType {
        case .rib:
            listener?.didTapPopBack()
        case .swiftUI:
            navigationPath.pop()
        }
    }
    
    private func popToRoot() {
        switch rootType {
        case .rib:
            listener?.didTapPopToRoot()
        case .swiftUI:
            navigationPath.popToRoot()
        }
    }
    
    private func handleDone() {
        switch rootType {
        case .rib:
            listener?.didTapDone()
        case .swiftUI:
            navigationPath.popToRoot()
        }
    }
}
