import Factory

extension Container {
    public var rootType: Factory<RootType> {
        self { .rib }
    }
}

public enum RootType {
    case rib
    case swiftUI
}
