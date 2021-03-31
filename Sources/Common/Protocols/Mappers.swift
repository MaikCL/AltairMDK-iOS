//
//  Created by Miguel Angel on 10-07-20.
//

import Foundation

/// Map from Domain Entity to Data or Presentation Model
public protocol ModelMapper {
    associatedtype Entity
    associatedtype Model
    static var mapEntityToModel: (Entity) throws -> Model { get }
}

/// Map from Data or Presentation Model to Entity
public protocol EntityMapper {
    associatedtype Model
    associatedtype Entity
    static var mapModelToEntity: (Model) throws -> Entity { get }
}

public enum MapperError: Error {
    /// There is not enough information to map the entity to model type
    case cantMapToModel
    
    /// There is not enough information to map the model to entity type
    case cantMapToEntity
}

extension MapperError {
    public var code: String {
        switch self {
            case .cantMapToModel: return "mdk.mp.1"
            case .cantMapToEntity: return "mdk.mp.2"
        }
    }
}

extension MapperError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .cantMapToModel:
                return "There is not enough information to map the entity to model type."
            case .cantMapToEntity:
                return "There is not enough information to map the model to entity type"
        }
    }
}

