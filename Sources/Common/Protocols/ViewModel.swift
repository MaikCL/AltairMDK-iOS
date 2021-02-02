//
//  Created by Miguel Angel on 17-02-21.
//

import Foundation

public protocol ViewModel: ObservableObject {
    associatedtype StateType
    associatedtype EventType
    var state: StateType { get }
    func send(event: EventType)
}
