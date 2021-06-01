//
//  CoreDataAgent.swift
//  
//
//  Created by Miguel Angel on 01-06-21.
//

import Combine
import CoreData
import Foundation

// TODO: Add Logger for track the exceptions and replace print - @mzapatae at 01/06/21
final class CoreDataAgent: StorageAgent {

    var managedContext: NSManagedObjectContext?

    required init(configuration: ConfigurationType) throws {
        switch configuration {
            case .basic:
                try initDB(modelName: configuration.identifier(), storeType: .sqLiteStoreType)
            case .inMemory:
                try initDB(modelName: configuration.identifier(), storeType: .inMemoryStoreType)
        }
    }
    
    private func initDB(modelName: String, storeType: StoreType) throws {
        let coordinator = try CoreDataStoreCoordinator.persistentStoreCoordinator(modelName: modelName, storeType: storeType)
        self.managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedContext?.persistentStoreCoordinator = coordinator
    }
    
    func insert(object: Storable) -> AnyPublisher<Void, StorageException> {
        guard let managedObject = object as? NSManagedObject else { return Fail(error: .objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: .notInitialized).eraseToAnyPublisher() }
        do {
            context.insert(managedObject)
            try context.save()
            return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
        } catch {
            print("Insert object error: \(error)")
            return Fail(error: .insertObjectFail).eraseToAnyPublisher()
        }
    }
    
    func insertAll(objects: [Storable]) -> AnyPublisher<Void, StorageException> {
        guard let managedObjects = objects as? [NSManagedObject] else { return Fail(error: .objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: .notInitialized).eraseToAnyPublisher() }
        do {
            managedObjects.forEach { context.insert($0) }
            try context.save()
            return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
        } catch {
            print("Insert all objects error: \(error)")
            return Fail(error: .insertObjectFail).eraseToAnyPublisher()
        }
    }
    
    func update(object: Storable) -> AnyPublisher<Void, StorageException> {
        guard let managedObject = object as? NSManagedObject else { return Fail(error: .objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: .notInitialized).eraseToAnyPublisher() }
        do {
            if managedObject.isUpdated {
                try context.save()
                return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
            } else {
                print("Not exist and update for the object")
                return Fail(error: .updateObjectFail).eraseToAnyPublisher()
            }
        } catch {
            print("Update object error: \(error)")
            return Fail(error: .updateObjectFail).eraseToAnyPublisher()
        }
    }
    
    func delete(object: Storable) -> AnyPublisher<Void, StorageException> {
        guard let managedObject = object as? NSManagedObject else { return Fail(error: .objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: .notInitialized).eraseToAnyPublisher() }
        do {
            context.delete(managedObject)
            try context.save()
            return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
        } catch {
            print("Delete object error: \(error)")
            return Fail(error: .deleteObjectFail).eraseToAnyPublisher()
        }
    }
    
    func deleteAll(_ model: Storable.Type, predicate: NSPredicate?) -> AnyPublisher<Void, StorageException> {
        guard let type = model as? NSManagedObject.Type else { return Fail(error: .objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: .notInitialized).eraseToAnyPublisher() }
        do {
            let fetchRequest = type.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = predicate

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)
            try context.save()
            return Just(()).setFailureType(to: StorageException.self).eraseToAnyPublisher()
        } catch {
            print("Delete all objects error: \(error)")
            return Fail(error: .deleteObjectFail).eraseToAnyPublisher()
        }
    }
    
    func readAll<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AnyPublisher<[T], StorageException> where T: Storable {
        guard let type = model as? NSManagedObject.Type else { return Fail(error: .objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: .notInitialized).eraseToAnyPublisher() }
        do {
            let fetchRequest = type.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            fetchRequest.predicate = predicate
            
            let results = try context.fetch(fetchRequest) as? [T] ?? []
            return Just(results).setFailureType(to: StorageException.self).eraseToAnyPublisher()
        } catch {
            print("Read all objects error: \(error)")
            return Fail(outputType: [T].self, failure: .readObjectFail).eraseToAnyPublisher()
        }
    }
   
}
