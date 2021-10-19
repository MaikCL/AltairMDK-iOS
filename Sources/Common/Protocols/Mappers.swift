import Foundation

/// Map from Domain Entity to Data or Presentation Model
public protocol ModelMapper {
    associatedtype Entity
    associatedtype Model
    static var mapEntityToModel: (Entity) -> Model { get }
}

/// Map from Data or Presentation Model to Domain Entity
public protocol EntityMapper {
    associatedtype Model
    associatedtype Entity
    static var mapModelToEntity: (Model) -> Entity { get }
}

/// Map from Domain Entity to Data or Presentation Model
public protocol ModelFailableMapper {
    associatedtype Entity
    associatedtype Model
    static var mapEntityToModel: (Entity) throws -> Model { get }
}

/// Map from Data or Presentation Model to Domain Entity
public protocol EntityFailableMapper {
    associatedtype Model
    associatedtype Entity
    static var mapModelToEntity: (Model) throws -> Entity { get }
}

public enum MapperException {
    /// There is not enough information to map the entity to model type
    case cantMapToModel
    
    /// There is not enough information to map the model to entity type
    case cantMapToEntity
}

extension MapperException: Exception {
    
    public var category: ExceptionCategory {
        .mappers
    }
    
    public var code: String {
        switch self {
            case .cantMapToModel: return "mdk.mp.01"
            case .cantMapToEntity: return "mdk.mp.02"
        }
    }
    
    public var errorTitle: String? {
        return "An exception occurred"
    }
    
    public var errorDescription: String? {
        switch self {
            case .cantMapToModel:
                return "There is not enough information to map the entity to model type."
            case .cantMapToEntity:
                return "There is not enough information to map the model to entity type"
        }
    }
}
