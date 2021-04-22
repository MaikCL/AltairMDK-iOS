//
//  Created by Miguel Angel on 25-03-21.
//

import Foundation

public protocol Store: ObservableObject {
    associatedtype State
    associatedtype Action
    var state: State { get }
    func trigger(action: Action)
}
