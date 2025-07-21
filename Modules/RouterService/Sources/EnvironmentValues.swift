import SwiftUI

public extension EnvironmentValues {
    @Entry var presentationStyle: NavigationStyle = .sheet
    @Entry var navigationPath: Binding<NavigationPath> = .constant(NavigationPath())
}
