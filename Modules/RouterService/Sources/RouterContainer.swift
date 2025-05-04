import Factory

public extension Container {
    var router: Factory<Router> {
        self { Router() }
            .singleton
    }
}

public final class RouterContainer: SharedContainer {
    @TaskLocal public static var shared = RouterContainer()
    public let manager = ContainerManager()
}
