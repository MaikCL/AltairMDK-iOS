//
//  Created by Miguel Angel on 31-03-21.
//

import Combine

public struct SideEffect<Action> {
    let run: (AnyPublisher<Action, Never>) -> AnyPublisher<Action, Never>
}

extension SideEffect {
    public init<Effect: Publisher>(effects: @escaping (Action) -> Effect) where Effect.Output == Action, Effect.Failure == Never {
        self.run = { action -> AnyPublisher<Action, Never> in
            action.map { effects($0) }.switchToLatest().eraseToAnyPublisher()
        }
    }
}
