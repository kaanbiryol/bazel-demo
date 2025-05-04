import Factory
import RouterService
import NetworkingInterface
import Networking
import ListInterface
import List
import DetailsInterface
import Details
import HomeInterface
import Home
import OrderInterface
import Order

extension Container: AutoRegistering {
    public func autoRegister() {
        networkingService.register { NetworkingImpl() }
        
        rentDetailsBuilder.register { binding in
            RentDetailsBuilder(selectionBinding: binding)
        }
        
        listBuilder.register {
            ListBuilder()
        }
        
        // Register Home module
        homeBuilder.register {
            HomeBuilder()
        }
        
        // Register Order module
        orderBuilder.register {
            OrderBuilder()
        }
    }
}
