//
//  Created by Miguel Angel on 20-07-20.
//

public enum Loadable<T> {
    case neverLoaded
    case loading
    case loaded(T)
}

extension Loadable: Equatable where T: Equatable { }

public protocol Functor {
    associatedtype A
    associatedtype B: Functor = Self
    
    func tryMap<C>(_ transform: (A) throws -> C) throws -> B where B.A == C
}

extension Loadable: Functor {
    public typealias A = T
    
    public func tryMap<C>(_ transform: (T) throws -> C) throws -> Loadable<C> {
        switch self {
            case .neverLoaded: return .neverLoaded
            case .loading: return .loading
            case .loaded(let value): return .loaded(try transform(value))
        }
    }
}
