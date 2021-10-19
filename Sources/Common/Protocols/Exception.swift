import Foundation

public protocol Exception: LocalizedError {
    var code: String { get }
    var category: ExceptionCategory { get }
    var errorTitle: String? { get }
    var errorDescription: String? { get }
}

public enum ExceptionCategory {
    case feature
    case network
    case storage
    case mappers
    case unknown
}

public enum GenericException: Exception {
    case unknown(_ underlying: Error)
    
    public var category: ExceptionCategory {
        .unknown
    }
    
    public var code: String {
        return "mdk.cmn.00"
    }
    
    public var errorTitle: String? {
        return "An Exception ocurred"
    }
    
    public var errorDescription: String? {
        switch self {
            case .unknown(let error):
                return "Error: \(error)"
        }
    }

}
