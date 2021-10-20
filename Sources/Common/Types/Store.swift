import Combine
import SwiftUI
import Foundation

public typealias Reducer<State, Action> = (inout State, Action) -> Void
public typealias SideEffect<State, Action> = (State, Action) -> AnyPublisher<Action, Never>?

public final class Store<State, Action>: ObservableObject {
    @Published public private(set) var state: State

    private let reducer: Reducer<State, Action>
    private let sideEffects: [SideEffect<State, Action>]
    private var cancellables = Set<AnyCancellable>()
    
    public init(state: State, reducer: @escaping Reducer<State, Action>, sideEffects: [SideEffect<State, Action>] = []) {
        self.state = state
        self.reducer = reducer
        self.sideEffects = sideEffects
    }
    
    public func trigger(_ action: Action) {
        //TODO: Improve with logger provider (or LoggerSideEffect)
        print("Executing Store with <\(genericTypeName)>")
        print("Action Triggered: \(action)")
        print("State Before: \(state)")
        
        reducer(&state, action)
        
        print("State After: \(state)")
        
        for sideEffect in sideEffects {
            guard let effect = sideEffect(state, action) else { break }
            effect
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: trigger)
                .store(in: &cancellables)
        }
    }
}

private extension Store {
    
    var genericTypeName: String {
        return String(describing: State.self) + "-" + String(describing: Action.self)
    }
    
}

public extension Store {

    func binding<Value>(for keyPath: KeyPath<State, Value>, transform: @escaping (Value) -> Action) -> Binding<Value> {
        Binding<Value>(
            get: { self.state[keyPath: keyPath] },
            set: { self.trigger(transform($0)) }
        )
    }

}
