//
//  Created by Miguel Angel on 13-07-20.
//

import Combine

public protocol NetworkProviderProtocol {
    var agent: NetworkAgent { get }
}

public enum NetworkStrategy {
    case nsUrlSession
}

public final class NetworkProvider: NetworkProviderProtocol {
    public let agent: NetworkAgent
    
    public init(strategy: NetworkStrategy) {
        switch strategy {
            case .nsUrlSession: agent = NSUrlSessionAgent()
        }
    }
}
