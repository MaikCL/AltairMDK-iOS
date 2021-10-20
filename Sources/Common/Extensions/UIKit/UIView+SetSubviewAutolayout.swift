import UIKit

extension UIView {
    
    public func setSubviewForAutoLayout(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }
    
    public func setSubviewsForAutoLayout(_ subviews: [UIView]) {
        subviews.forEach(setSubviewForAutoLayout(_:))
    }
    
}

