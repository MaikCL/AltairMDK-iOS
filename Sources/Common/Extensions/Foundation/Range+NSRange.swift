//
//  Range+NSRange.swift
//  
//
//  Created by Miguel Angel on 09-08-21.
//

import Foundation

extension Range where Bound == String.Index {
    
    public var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset, length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset)
    }

}
