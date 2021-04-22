//
//  Created by Miguel Angel on 09-02-21.
//

import Foundation
import Combine

extension Publishers {
    
    public static func store<State, Action, Scheduler: Combine.Scheduler>(
        initial: State,
        input: PassthroughSubject<Action, Never>,
        reduce: @escaping (State, Action) -> State,
        scheduler: Scheduler,
        sideEffects: [SideEffect<Action>]
    ) -> AnyPublisher<State, Never> {
        
        let state = CurrentValueSubject<State, Never>(initial)
        let actions = sideEffects.map { $0.run(input.eraseToAnyPublisher()) }

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
