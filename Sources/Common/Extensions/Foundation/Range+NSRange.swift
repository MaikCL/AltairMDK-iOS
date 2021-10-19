import Foundation

extension Range where Bound == String.Index {
    
    public var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset, length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset)
    }

}
