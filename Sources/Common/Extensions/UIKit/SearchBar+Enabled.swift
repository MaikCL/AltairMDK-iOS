import UIKit

extension UISearchBar {
    public func enable() {
        isUserInteractionEnabled = true
        alpha = 1.0
    }

    public func disable() {
        isUserInteractionEnabled = false
        alpha = 0.5
    }
}

