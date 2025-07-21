import SwiftUI
import ListInterface
import Factory

struct RootSwiftUI: View {
    var body: some View {
        Color.clear.frame(width: 0, height: 0)
            .routeTo(
                route: ListRoute(),
                isActive: .constant(true),
                style: .embed
            )
    }
}
