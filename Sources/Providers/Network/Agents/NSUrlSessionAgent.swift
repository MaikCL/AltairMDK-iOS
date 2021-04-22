//
//  Created by Miguel Angel on 13-07-20.
//

import AltairMDKCommon
import Foundation
import Combine

final class NSUrlSessionAgent: NetworkAgent {
    
    public init () { }
    
    public func run<Endpoint>(_ endpoint: Endpoint) -> AnyPublisher<Endpoint.APIResponse, NetworkException> where Endpoint: EndpointProvider {
        guard let url = URL(string: endpoint.path) else {
            return AnyPublisher(Fail<Endpoint.APIResponse, NetworkException>(error: .invalidURL))
        }
        
        guard Reachability.isNetworkReachable() else {
            return AnyPublisher(Fail<Endpoint.APIResponse, NetworkException>(error: .unreachable))
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = httpMethod(from: endpoint.method)
        request.allHTTPHeaderFields = endpoint.headers

        if endpoint.parameters != nil {
            guard let postParams = try? JSONEncoder().encode(endpoint.parameters) else {
                return AnyPublisher(Fail<Endpoint.APIResponse, NetworkException>(error: .invalidPostParams))
            }
            request.httpBody = postParams
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { data, response in
                let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                let statusCode = HTTPStatusCode(rawCode: code)
                guard statusCode.responseType == .success else {
                    if let apiError = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        throw NetworkException.apiError(statusCode, apiError)
                    } else {
                        throw NetworkException.invalidStatusCode(statusCode)
                    }
                }
                return data
            }
            .decode(type: Endpoint.APIResponse.self, decoder: JSONDecoder(), errorTransform: { NetworkException.unableToDecode($0) })
            .mapError { $0 as? NetworkException ?? .unknown($0) }
            .eraseToAnyPublisher()
    }
    
    fileprivate func httpMethod(from method: HttpMethod) -> String {
        switch method {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
