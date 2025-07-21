import Factory

extension Container {
    public var rootType: Factory<RootType> {
        self { .swiftUI }
    }
}

public enum RootType {
    case rib
    case swiftUI
}
