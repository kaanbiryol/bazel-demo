import Foundation
import RouterService

public struct DetailsRoute: Route {
    public static var identifier: String = "details_route"
    
    public let element: Int
    public let analyticsContext: String
    
    public init(element: Int, analyticsContext: String = "Default") {
        self.element = element
        self.analyticsContext = analyticsContext
    }
} 
