import SwiftUI

public extension Binding where Value == NavigationPath {
    func push<R: Route>(_ route: R) {
        self.wrappedValue.append(AnyRoute(route))
    }
    
    func pop() {
        if !self.wrappedValue.isEmpty {
            self.wrappedValue.removeLast()
        }
    }
    
    func popToRoot() {
        self.wrappedValue.removeLast(self.wrappedValue.count)
    }
}

public extension NavigationLink where Destination == Never {
    init<R: Route>(route: R, @ViewBuilder label: () -> Label) {
        self.init(value: AnyRoute(route), label: label)
    }
}

public extension NavigationPath {
    
    mutating func push(to route: any Route) {
        self.append(AnyRoute(route))
    }
    
    mutating func pop() {
        self.removeLast()
    }
    
    mutating func popToRoot() {
        self = NavigationPath()
    }
}

