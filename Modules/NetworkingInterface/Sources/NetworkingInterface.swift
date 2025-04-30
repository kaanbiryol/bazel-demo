import Foundation
import Factory

public extension Container {
  var networkingService: Factory<NetworkingService> {
    Factory(self) {
      fatalError("🚨 NetworkingService not registered – make sure your App registers one.")
    }
  }
}
    
public protocol NetworkingService {
    func fetchTitle() -> String
    func fetchDetails() -> String
}
