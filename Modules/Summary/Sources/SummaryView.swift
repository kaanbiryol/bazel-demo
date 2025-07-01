import RouterService
import RIBs
import Foundation
import SwiftUI
import NetworkingInterface
import SummaryInterface
import UIKit

struct SummaryView: View {
    
    @Binding var selection: SummarySelection
    @Environment(\.dismiss) private var dismiss
    
    @State private var isActive: Bool = false
    @State private var name: String = "Alice"
    
    var body: some View {
        HStack {
            Button("1") {
                selection = SummarySelection(value: "1")
                dismiss()
            }
            Button("2") {
                selection = SummarySelection(value: "2")
                dismiss()
            }
            Button("3") {
                selection = SummarySelection(value: "3")
                isActive = true
//                dismiss()
            }
        }
//        Text(name)
//            .onAppear(perform: {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    name = "KAAN"
//                }
//            })
        .routeTo(route: TestRoute(), isActive: $isActive, style: .push)
    }
    
}

public class TestBuilder: Builder2 {
//    @Injected(\.networkingService) private var networkingService
//    @Injected(\.router) private var router
    
    public init() {
         
    }
    
    public func buildView(fromRoute route: Route?) -> AnyView {
        return AnyView(
            Text("KAAN")
        )
    }
}


public struct TestRoute: Route {
    public static var identifier: String = "rent_details_route2"
    
    public init() {
    }
    
    public func getBuilder() -> any Builder2 {
        return TestBuilder()
    }
}
