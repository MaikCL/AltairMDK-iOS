//
//  Created by Miguel Angel on 13-07-20.
//  Copyright © 2020 Miguel A. Zapata. All rights reserved.
//

import AltairMDKCommon
import Combine

public protocol NetworkAgent: AnyObject {
    func run<Endpoint: EndpointProvider>(_ endpoint: Endpoint) -> AnyPublisher<Endpoint.APIResponse, NetworkError>
}

public enum NetworkError: Exception {
    case some(Error)
    case apiError(HTTPStatusCode, [String: Any])
    case invalidURL
    case unreachable
    case invalidStatusCode(HTTPStatusCode)
    case invalidPostParams
}

extension NetworkError {
    public var code: String {
        switch self {
            case .some: return "mdk.nw.1"
            case .apiError: return "mdk.nw.2"
            case .invalidURL: return "mdk.nw.3"
            case .unreachable: return "mdk.nw.4"
            case .invalidPostParams: return "mdk.nw.5"
            case .invalidStatusCode: return "mdk.nw.6"
        }
    }
    
    public var errorDescription: String? {
        switch self {
            case .some(let error): return "Unknown Network Error: \(error.localizedDescription)"
            case .apiError(let statusCode, let params): return "Api Error - Code \(statusCode.rawValue): \(params.debugDescription)"
            case .invalidURL: return "The url you are trying to access is invalid"
            case .unreachable: return "The network device is unreachable."
            case .invalidPostParams: return "The POST parameters are invalid"
            case .invalidStatusCode(let statusCode): return "Server Error - Code \(statusCode.rawValue)"
        }
    }
}
