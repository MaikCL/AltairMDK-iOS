//
//  StorageAgent.swift
//  
//
//  Created by Miguel Angel on 25-05-21.
//

import Combine
import Foundation
import AltairMDKCommon

public protocol StorageAgent: AnyObject {
    func create<T: Storable>(_ model: T.Type) -> T?
    func insert(object: Storable) -> AnyPublisher<Void, Error>
    func insertAll(objects: [Storable]) -> AnyPublisher<Void, Error>
    func update(object: Storable) -> AnyPublisher<Void, Error>
    func delete(object: Storable) -> AnyPublisher<Void, Error>
    func deleteAll(_ model: Storable.Type, predicate: NSPredicate?) -> AnyPublisher<Void, Error>
    func readFirst<T: Storable>(_ model: T.Type, predicate: NSPredicate?) -> AnyPublisher<T?, Error>
    func readAll<T: Storable>(_ model: T.Type, predicate: NSPredicate?) -> AnyPublisher<[T], Error>
}

public enum StorageException {
    case unknown(Error)
    case notInitialized
    case readObjectFail
    case insertObjectFail
    case updateObjectFail
    case deleteObjectFail
    case storePathNotFound
    case objectNotSupported
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
            case .readObjectFail: return "mdk.stg.03"
            case .insertObjectFail: return "mdk.stg.04"
            case .updateObjectFail: return "mdk.stg.05"
            case .deleteObjectFail: return "mdk.stg.06"
            case .storePathNotFound: return "mdk.stg.07"
            case .objectNotSupported: return "mdk.stg.08"
            case .dbModelFileNotFound: return "mdk.stg.09"
            case .dbModelCreationFail: return "mdk.stg.10"
        }
    }
    
    public var errorTitle: String? {
        return "An exception occurred"
    }
    
    public var errorDescription: String? {
        switch self {
            case .unknown(let error):
                return "Unknown Storage Error: \(error.localizedDescription)"
            case .notInitialized:
                return "DB not initialized for previus error"
            case .readObjectFail:
                return "Read object failed!"
            case .insertObjectFail:
                return "Insert object failed!"
            case .updateObjectFail:
                return "Update object failed!"
            case .deleteObjectFail:
                return "Delete object failed!"
            case .storePathNotFound:
                return "Gettings document directory fail"
            case .objectNotSupported:
                return "Object type for the concrete storage is not supported"
            case .dbModelFileNotFound:
                return "DB File not found"
            case .dbModelCreationFail:
                return "Object model creation fail"
        }
    }
    
}
