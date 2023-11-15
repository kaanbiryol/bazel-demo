import Foundation

private class ListBundle {}

extension Bundle {
    static let listBundle = Bundle(for: ListBundle.self)
}
