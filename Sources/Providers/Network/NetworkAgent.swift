//
//  Created by Miguel Angel on 13-07-20.
//  Copyright © 2020 Miguel A. Zapata. All rights reserved.
//

import AltairMDKCommon
import Combine

public protocol NetworkAgent: AnyObject {
    func run<Endpoint: EndpointProvider>(_ endpoint: Endpoint) -> AnyPublisher<Endpoint.APIResponse, NetworkException>
}

public enum NetworkException {
    case unknown(Error)
    case apiError(HTTPStatusCode, [String: Any])
    case invalidURL
    case unreachable
    case unableToDecode(Error)
    case invalidStatusCode(HTTPStatusCode)
    case invalidPostParams
}

extension NetworkException: Exception {
    public var category: ExceptionCategory {
        .network
    }
    
    public var code: String {
        switch self {
            case .unknown: return "mdk.nw.01"
            case .apiError: return "mdk.nw.02"
            case .invalidURL: return "mdk.nw.03"
            case .unreachable: return "mdk.nw.04"
            case .unableToDecode: return "mdk.nw.05"
            case .invalidPostParams: return "mdk.nw.06"
            case .invalidStatusCode: return "mdk.nw.07"
        }
    }
    
    public var errorDescription: String? {
        switch self {
            case .unknown(let error):
                return "Unknown Network Error: \(error.localizedDescription)"
            case .apiError(let statusCode, let params):
                return "Api Error - Code \(statusCode.rawValue): \(params.debugDescription)"
            case .invalidURL:
                return "The url you are trying to access is invalid"
            case .unreachable:
                return "The network device is unreachable."
            case .unableToDecode(let error):
                return "Unable to decode - Error: \(error.localizedDescription)"
            case .invalidPostParams:
                return "The POST parameters are invalid"
            case .invalidStatusCode(let statusCode):
                return "Server Error - Code \(statusCode.rawValue)"
        }
    }
}
