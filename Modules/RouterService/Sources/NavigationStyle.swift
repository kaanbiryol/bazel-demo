import SwiftUI

public enum NavigationStyle {
    case push(_ navigationPath: Binding<NavigationPath>)
    case sheet
    case fullScreenCover
    case embed
}

extension NavigationStyle: Equatable {
    public static func == (lhs: NavigationStyle, rhs: NavigationStyle) -> Bool {
        switch (lhs, rhs) {
        case (.push, .push): return true
        case (.sheet, .sheet): return true
        case (.fullScreenCover, .fullScreenCover): return true
        case (.embed, .embed): return true
        default: return false
        }
    }
}
