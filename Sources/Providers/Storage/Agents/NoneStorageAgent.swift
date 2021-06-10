//
//  NoneAgent.swift
//  
//
//  Created by Miguel Angel on 01-06-21.
//

import Combine
import Foundation

final class NoneStorageAgent: StorageAgent {
    
    func create<T>(_ model: T.Type) -> T? where T: Storable {
        print("Object is supposed to be created but nothing has happened")
        return nil
    }

    func insert(object: Storable) -> AnyPublisher<Void, StorageException> {
        print("Object is supposed to be inserted but nothing has happened")
        return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
    }
    
    func insertAll(objects: [Storable]) -> AnyPublisher<Void, StorageException> {
        print("Objects is supposed to be inserted but nothing has happened")
        return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
    }
    
    func update(object: Storable) -> AnyPublisher<Void, StorageException> {
        print("Object is supposed to be updated but nothing has happened")
        return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
    }
    
    func delete(object: Storable) -> AnyPublisher<Void, StorageException> {
        print("Object is supposed to be deleted but nothing has happened")
        return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
    }
    
    func deleteAll(_ model: Storable.Type, predicate: NSPredicate?) -> AnyPublisher<Void, StorageException> {
        print("Objects is supposed to be deleted but nothing has happened")
        return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
    }
    
    func readAll<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AnyPublisher<[T], StorageException> where T: Storable {
        print("Objects is supposed to be readed but nothing has happened")
        return Just([]).setFailureType(to: StorageException.self).eraseToAnyPublisher()
    }
    
    func read2All<T>(predicate: NSPredicate?, sorted: Sorted?) -> AnyPublisher<[T], StorageException> where T : Storable {
        print("Objects is supposed to be readed but nothing has happened")
        return Just([]).setFailureType(to: StorageException.self).eraseToAnyPublisher()
    }
    
}
