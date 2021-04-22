//
//  Created by Miguel Angel on 13-07-20.
//

import AltairMDKCommon

public typealias Parameters = [String: AnyCodable]
public typealias Path = String
public typealias Headers = [String: String]

public enum HttpMethod {
    case get, post, put, patch, delete
}

public protocol EndpointProvider: AnyObject {
    associatedtype APIResponse: Decodable
    var headers: Headers { get }
    var method: HttpMethod { get }
    var path: Path { get }
    var parameters: Parameters? { get }
}

// TODO: Improve with Builder Pattern and improve access - Miguel A. Zapata (13/07/20)
public class Endpoint<APIResponse: Decodable>: EndpointProvider {
    public var headers: Headers
    public var method: HttpMethod
    public var path: Path
    public var parameters: Parameters?
    
    public init(headers: Headers, method: HttpMethod, path: Path, parameters: Parameters? = nil) {
        self.headers = headers
        self.method = method
        self.path = path
        self.parameters = parameters
    }
    
}
