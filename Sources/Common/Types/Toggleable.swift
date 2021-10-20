public enum Toggleable: Equatable {
    case on
    case off
    
    public var isOn: Bool {
        self == .on
    }
    
    public var isOff: Bool {
        self == .off
    }
    
    public mutating func toggle() {
        switch self {
            case .on:
                self = .off
            case .off:
                self = .on
        }
    }
    
    public var state: Bool {
        switch self {
            case .on:
                return true
            case .off:
                return false
        }
    }
}
