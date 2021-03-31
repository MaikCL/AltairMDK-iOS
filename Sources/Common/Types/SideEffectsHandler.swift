//
//  Created by Miguel Angel on 31-03-21.
//

import Combine

open class SideEffectsHandler<Action> {
    public init() { }
    open func whenInput(action: AnyPublisher<Action, Never>) -> SideEffect<Action> {
        SideEffect { _ in action }
    }
}
