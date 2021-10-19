import UIKit

public protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

public extension Coordinator {
    
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }

}
