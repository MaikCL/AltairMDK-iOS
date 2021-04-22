//
//  Created by Miguel Angel on 25-03-21.
//

import Combine

public protocol UseCase: AnyObject {
    associatedtype T
    func execute() -> AnyPublisher<T, Error>
}
