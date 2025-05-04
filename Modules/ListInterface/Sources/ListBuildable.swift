import Factory
import RouterService

public protocol ListBuildable: Builder2 {}

public extension Container {
    var listBuilder: Factory<ListBuildable> {
        Factory(self) {
            fatalError("🚨 NetworkingService not registered – make sure your App registers one.")
        }
    }
}
