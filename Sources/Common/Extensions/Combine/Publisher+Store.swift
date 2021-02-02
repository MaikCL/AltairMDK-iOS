//
//  Created by Miguel Angel on 09-02-21.
//

import Combine

public struct SideEffect<State, Action> {
    let run: (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
}

extension SideEffect {
    public init<Effect: Publisher>(effects: @escaping (State) -> Effect) where Effect.Output == Action, Effect.Failure == Never {
        self.run = { state -> AnyPublisher<Action, Never> in
            state.map { effects($0) }.switchToLatest().eraseToAnyPublisher()
        }
    }
}

extension Publishers {
    public static func store<State, Action, Scheduler: Combine.Scheduler>(
        initial: State,
        reduce: @escaping (State, Action) -> State,
        scheduler: Scheduler,
        sideEffects: [SideEffect<State, Action>]
    ) -> AnyPublisher<State, Never> {

        let state = CurrentValueSubject<State, Never>(initial)
        let actions = sideEffects.map { sideEffects in sideEffects.run(state.eraseToAnyPublisher()) }

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
