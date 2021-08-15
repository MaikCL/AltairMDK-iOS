//
//  UIView+SetCornerRadius.swift
//  
//
//  Created by Miguel Angel on 03-08-21.
//

import UIKit

extension UIView {
    
    public func set(cornerRadius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
}
