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

    required init(configuration: ConfigurationType) {
        do {
            switch configuration {
                case .basic(dbFile: let dbFile):
                    try initDB(urlModel: dbFile, storeType: .sqLiteStoreType)
                case .inMemory(identifier: _):
                    try initDB(urlModel: .none, storeType: .inMemoryStoreType)
            }
        } catch {
            print("StorageAgent: CoreData initialization failed!")
            print("Error: \(error)")
        }
    }
    
    private func initDB(urlModel: URL?, storeType: StoreType) throws {
        let coordinator = try CoreDataStoreCoordinator.persistentStoreCoordinator(urlModel: urlModel, storeType: storeType)
        self.managedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.managedContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.managedContext?.persistentStoreCoordinator = coordinator
    }
    
    // TODO: Try to create the object using the context init: "let object = CoreDataModel(context: context)" - @mzapatae at 02/06/21
    func create<T>(_ model: T.Type) -> T? where T: Storable {
        guard
            let context = managedContext,
            let entityDescription = NSEntityDescription.entity(forEntityName: model.entityName, in: context)
        else {
            print("Failed to create CoreData entity description \(String(describing: model.self))")
            return nil
        }
        return NSManagedObject(entity: entityDescription, insertInto: context) as? T
    }
    
    func insert(object: Storable) -> Future<Void, Error> {
        return Future() { promise in
            guard let managedObject = object as? NSManagedObject else { return promise(.failure(StorageException.notInitialized)) }
            guard let context = self.managedContext else { return promise(.failure(StorageException.objectNotSupported)) }
            do {
                context.insert(managedObject)
                try context.save()
                promise(.success(()))
            } catch {
                print("Insert object error: \(error)")
                promise(.failure(StorageException.insertObjectFail))
            }
        }
    }
    
    func insertAll(objects: [Storable]) -> Future<Void, Error> {
        return Future() { promise in
            guard let managedObjects = objects as? [NSManagedObject] else { return promise(.failure(StorageException.objectNotSupported)) }
            guard let context = self.managedContext else { return promise(.failure(StorageException.notInitialized)) }
            do {
                managedObjects.forEach { context.insert($0) }
                try context.save()
                promise(.success(()))
            } catch {
                print("Insert all objects error: \(error)")
                promise(.failure(StorageException.insertObjectFail))
            }
        }
    }

    func update(object: Storable) -> Future<Void, Error> {
        return Future() { promise in
            guard let managedObject = object as? NSManagedObject else { return promise(.failure(StorageException.objectNotSupported)) }
            guard let context = self.managedContext else { return promise(.failure(StorageException.notInitialized)) }
            do {
                if managedObject.isUpdated {
                    try context.save()
                    promise(.success(()))
                } else {
                    print("Not exist and update for the object")
                    promise(.failure(StorageException.updateObjectFail))
                }
            } catch {
                print("Update object error: \(error)")
                promise(.failure(StorageException.updateObjectFail))
            }
        }
    }
    
    func delete(object: Storable) -> Future<Void, Error> {
        return Future() { promise in
            guard let managedObject = object as? NSManagedObject else { return promise(.failure(StorageException.objectNotSupported)) }
            guard let context = self.managedContext else { return promise(.failure(StorageException.notInitialized)) }
            do {
                context.delete(managedObject)
                try context.save()
                promise(.success(()))
            } catch {
                print("Delete object error: \(error)")
                promise(.failure(StorageException.deleteObjectFail))
            }
        }
    }
    
    func deleteAll(_ model: Storable.Type, predicate: NSPredicate?) -> Future<Void, Error> {
        return Future() { promise in
            guard let context = self.managedContext else { return promise(.failure(StorageException.notInitialized)) }
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: model.entityName)
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.predicate = predicate

                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
                try context.save()
                promise(.success(()))
            } catch {
                print("Delete all objects error: \(error)")
                promise(.failure(StorageException.deleteObjectFail))
            }
        }

    }
    
    func readFirst<T>(_ model: T.Type, predicate: NSPredicate?) -> Future<T?, Error> where T: Storable {
        return Future() { promise in
            guard let context = self.managedContext else { return promise(.failure(StorageException.notInitialized)) }
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: model.entityName)
                fetchRequest.predicate = predicate
                
                let result = try context.fetch(fetchRequest).first as? T
                promise(.success(result))
            } catch {
                print("Read First object error: \(error)")
                return promise(.failure(StorageException.readObjectFail))
            }
        }
    }
    
    func readAll<T>(_ model: T.Type, predicate: NSPredicate?) -> Future<[T], Error> where T: Storable {
        return Future() { promise in
            guard (model as? NSManagedObject.Type) != nil else { return promise(.failure(StorageException.objectNotSupported)) }
            guard let context = self.managedContext else { return promise(.failure(StorageException.notInitialized)) }
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: model.entityName)
                fetchRequest.predicate = predicate
                let results = try context.fetch(fetchRequest) as? [T] ?? []
                promise(.success(results))
            } catch {
                print("Read all objects error: \(error)")
                return promise(.failure(StorageException.readObjectFail))
            }
        }
    }
   
}
