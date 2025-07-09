import SelectionRIB
import Selection
import SelectionInterface
import Factory
import RouterService
import NetworkingInterface
import Networking
import ListInterface
import List
import SummaryInterface
import Summary
import HomeInterface
import Home
import OrderInterface
import Order
import RIBs
import RootRIB

// MARK: - Static dependencies

extension Container {
    
    var rootType: Factory<RootType> {
        self { .rib }
    }
    
    var rootRIBBuilder: Factory<RootRIBBuildable> {
        self { RootRIBBuilder() }
    }
}

// MARK: - Dynamic dependencies

extension Container: AutoRegistering {
    public func autoRegister() {
        networkingService.register {
            NetworkingImpl()
        }
        
        summaryBuilder.register { binding in
            SummaryBuilder(selectionBinding: binding)
        }
        
        listBuilder.register {
            ListBuilder()
        }
        
        listRIBBuilder.register {
            ListRIBBuilder()
        }
        
        homeBuilder.register {
            HomeBuilder()
        }
        
        orderBuilder.register {
            OrderBuilder()
        }
        
        selectionBuilder.register { binding in
            SelectionBuilder(selectionBinding: binding)
        }
        
    }
}

