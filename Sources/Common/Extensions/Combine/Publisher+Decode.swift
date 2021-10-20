import Foundation
import Combine

extension Publisher {
    
    public func decode<Response, Coder>(type: Response.Type, decoder: Coder, errorTransform: @escaping (Error) -> Failure) -> Publishers.FlatMap<Publishers.MapError<Publishers.Decode<Just<Self.Output>, Response, Coder>, Self.Failure>, Self> where Response: Decodable, Coder: TopLevelDecoder, Self.Output == Coder.Input {
        
        return flatMap {
            Just($0).decode(type: type, decoder: decoder).mapError { errorTransform($0) }
        }
    }
    
}
