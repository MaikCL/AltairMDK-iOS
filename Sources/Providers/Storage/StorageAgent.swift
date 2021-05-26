//
//  StorageAgent.swift
//  
//
//  Created by Miguel Angel on 25-05-21.
//

import Combine
import AltairMDKCommon

public protocol StorageAgent: AnyObject {
    associatedtype Storable
    associatedtype Predicate
    func insert(_ object: Storable) -> AnyPublisher<Void, StorageException>
    func insertAll(_ objects: [Storable]) -> AnyPublisher<Void, StorageException>
    func update(_ object: Storable) -> AnyPublisher<Void, StorageException>
    func delete(_ object: Storable) -> AnyPublisher<Void, StorageException>
    func deleteAll(_ model: Storable.Type, predicate: Predicate?) -> AnyPublisher<Void, StorageException>
    func readAll(_ model: Storable.Type, predicate: Predicate?, sorted: Sorted?) -> AnyPublisher<[Storable], StorageException>
}

public enum StorageException {
    case unknown(Error)
    case notInitialized
    case storePathNotFound
    case dbModelFileNotFound
    case dbModelCreationFail
}

extension StorageException: Exception {
 
    public var category: ExceptionCategory {
        .storage
    }
    
    public var code: String {
        switch self {
            case .unknown: return "mdk.stg.01"
            case .notInitialized: return "mdk.stg.02"
            case .storePathNotFound: return "mdk.stg.03"
            case .dbModelFileNotFound: return "mdk.stg.04"
            case .dbModelCreationFail: return "mdk.stg.05"
        }
    }
    
    public var errorDescription: String? {
        switch self {
            case .unknown(let error):
                return "Unknown Storage Error: \(error.localizedDescription)"
            case .notInitialized:
                return "DB not initialized"
            case .storePathNotFound:
                return "Gettings document directory fail"
            case .dbModelFileNotFound:
                return "DB File not found"
            case .dbModelCreationFail:
                return "Object model creation fail"

        }
    }
    
}
