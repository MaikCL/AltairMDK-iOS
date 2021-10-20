import Combine

@available(*, deprecated, message: "Use the new MVI arqueo-type")
public struct SideEffectLegacy<State, Action> {
    public let run: (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
}

@available(*, deprecated, message: "Use the new MVI arqueo-type")
extension SideEffectLegacy {
    public init<Effect: Publisher>(effects: @escaping (State) -> Effect) where Effect.Output == Action, Effect.Failure == Never {
        self.run = { state -> AnyPublisher<Action, Never> in
            state.map { effects($0) }.switchToLatest().eraseToAnyPublisher()
        }
    }
}




