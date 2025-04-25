import Foundation

// Helper for feature initialization
public extension Feature {
    static func initialize(withStore store: StoreInterface) -> Self {
        let instance = self.init()
        instance.resolve(withStore: store)
        return instance
    }
}
