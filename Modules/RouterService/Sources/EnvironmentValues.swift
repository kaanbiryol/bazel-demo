import SwiftUI

extension EnvironmentValues {
    @Entry public var presentationStyle: NavigationStyle = .sheet
    @Entry public var navigationPath: Binding<NavigationPath> = .constant(NavigationPath())
}
