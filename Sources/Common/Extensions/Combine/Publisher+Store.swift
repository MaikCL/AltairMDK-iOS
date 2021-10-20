import Foundation
import Combine

extension Publishers {
    
    @available(*, deprecated, message: "Use the new MVI type Store instead")
    public static func store<State, Action, Scheduler: Combine.Scheduler>(
        initial: State,
        reduce: @escaping (State, Action) -> State,
        scheduler: Scheduler,
        sideEffects: [SideEffectLegacy<State, Action>]
    ) -> AnyPublisher<State, Never> {
        
        let state = CurrentValueSubject<State, Never>(initial)
        let actions = sideEffects.map { $0.run(state.eraseToAnyPublisher()) }

        return Deferred {
            Publishers.MergeMany(actions)
                .receive(on: scheduler)
                .scan(initial, reduce)
                .handleEvents(receiveOutput: state.send)
                .receive(on: scheduler)
                .prepend(initial)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
}
