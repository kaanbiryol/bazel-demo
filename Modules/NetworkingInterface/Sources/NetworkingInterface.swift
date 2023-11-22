import Foundation

public protocol NetworkingService {
    func fetchTitle() -> String
    func fetchDetails() -> String
}
