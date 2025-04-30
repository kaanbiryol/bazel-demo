import Factory
import RouterService
import NetworkingInterface
import Networking
import ListInterface
import List
import DetailsInterface
import Details

extension Container: AutoRegistering {
    public func autoRegister() {
        networkingService.register { NetworkingImpl() }
        
        rentDetailsBuilder.register { binding in
            RentDetailsBuilder(selectionBinding: binding)
        }
        
        listBuilder.register {
            ListBuilder()
        }
    }
}
