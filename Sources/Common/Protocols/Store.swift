//
//  Created by Miguel Angel on 25-03-21.
//

import SwiftUI
import Foundation

public protocol Store: ObservableObject {
    associatedtype State
    associatedtype Action
    var state: State { get }
    func trigger(_ action: Action)
}

public extension Store {
    
    func binding<Value>(for keyPath: KeyPath<State, Value>, transform: @escaping (Value) -> Action) -> Binding<Value> {
        Binding<Value>(
            get: { self.state[keyPath: keyPath] },
            set: { self.trigger(transform($0)) }
        )
    }

}
