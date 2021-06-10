//
//  Created by Miguel Angel on 31-03-21.
//

import Combine

public struct SideEffect<State, Action> {
    public let run: (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
}

extension SideEffect {
    public init<Effect: Publisher>(effects: @escaping (State) -> Effect) where Effect.Output == Action, Effect.Failure == Never {
        self.run = { state -> AnyPublisher<Action, Never> in
            state.map { effects($0) }.switchToLatest().eraseToAnyPublisher()
        }
    }
}
