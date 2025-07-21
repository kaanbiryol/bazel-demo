import Factory
import RouterService

public protocol ListBuildable: RouteBuilder {}

public extension Container {
    var listBuilder: Factory<ListBuildable> {
        Factory(self) {
            fatalError("🚨 NetworkingService not registered – make sure your App registers one.")
        }
    }
    
    var listRIBBuilder: Factory<ListRIBBuildable> {
        Factory(self) {
            fatalError("🚨 NetworkingService not registered – make sure your App registers one.")
        }
    }
}
