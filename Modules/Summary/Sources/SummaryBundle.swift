import Foundation

private class DetailsBundle {}

extension Bundle {
    static let details = Bundle(for: DetailsBundle.self)
}
