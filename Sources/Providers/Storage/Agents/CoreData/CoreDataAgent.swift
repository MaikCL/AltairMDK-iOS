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
    
    func insert(object: Storable) -> AnyPublisher<Void, Error> {
        guard let managedObject = object as? NSManagedObject else { return Fail(error: StorageException.objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: StorageException.notInitialized).eraseToAnyPublisher() }
        do {
            context.insert(managedObject)
            try context.save()
            return Result.Publisher(()).eraseToAnyPublisher()
        } catch {
            print("Insert object error: \(error)")
            return Fail(error: StorageException.insertObjectFail).eraseToAnyPublisher()
        }
    }
    
    func insertAll(objects: [Storable]) -> AnyPublisher<Void, Error> {
        guard let managedObjects = objects as? [NSManagedObject] else { return Fail(error: StorageException.objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: StorageException.notInitialized).eraseToAnyPublisher() }
        do {
            managedObjects.forEach { context.insert($0) }
            try context.save()
            return Result.Publisher(()).eraseToAnyPublisher()
        } catch {
            print("Insert all objects error: \(error)")
            return Fail(error: StorageException.insertObjectFail).eraseToAnyPublisher()
        }
    }
    
    func insertAll(objects: [Storable]) -> Future<Void, Error> {
        return Future() { promise in
            guard let managedObjects = objects as? [NSManagedObject] else {
                return promise(.failure(StorageException.objectNotSupported))
            }
            guard let context = self.managedContext else {
                return promise(.failure(StorageException.notInitialized))
            }
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
    
//    func insertAll(objects: [Storable]) {
//        guard let managedObjects = objects as? [NSManagedObject] else { return }
//        guard let context = managedContext else { return }
//        context.perform {
//            do {
//                managedObjects.forEach { context.insert($0) }
//                try context.save()
//            } catch {
//                let error = error
//                print("Insert all objects error: \(error)")
//            }
//        }
//    }
    
    func update(object: Storable) -> AnyPublisher<Void, Error> {
        guard let managedObject = object as? NSManagedObject else { return Fail(error: StorageException.objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: StorageException.notInitialized).eraseToAnyPublisher() }
        do {
            if managedObject.isUpdated {
                try context.save()
                return Result.Publisher(()).eraseToAnyPublisher()
            } else {
                print("Not exist and update for the object")
                return Fail(error: StorageException.updateObjectFail).eraseToAnyPublisher()
            }
        } catch {
            print("Update object error: \(error)")
            return Fail(error: StorageException.updateObjectFail).eraseToAnyPublisher()
        }
    }
    
    func delete(object: Storable) -> AnyPublisher<Void, Error> {
        guard let managedObject = object as? NSManagedObject else { return Fail(error: StorageException.objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: StorageException.notInitialized).eraseToAnyPublisher() }
        do {
            context.delete(managedObject)
            try context.save()
            return Result.Publisher(()).eraseToAnyPublisher()
        } catch {
            print("Delete object error: \(error)")
            return Fail(error: StorageException.deleteObjectFail).eraseToAnyPublisher()
        }
    }
    
    func deleteAll(_ model: Storable.Type, predicate: NSPredicate?) -> AnyPublisher<Void, Error> {
        guard let type = model as? NSManagedObject.Type else { return Fail(error: StorageException.objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: StorageException.notInitialized).eraseToAnyPublisher() }
        do {
            let fetchRequest = type.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = predicate

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)
            try context.save()
            return Result.Publisher(()).eraseToAnyPublisher()
        } catch {
            print("Delete all objects error: \(error)")
            return Fail(error: StorageException.deleteObjectFail).eraseToAnyPublisher()
        }
    }
    
    func readFirst<T>(_ model: T.Type, predicate: NSPredicate?) -> AnyPublisher<T?, Error> where T: Storable {
        guard let type = model as? NSManagedObject.Type else { return Fail(error: StorageException.objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: StorageException.notInitialized).eraseToAnyPublisher() }
        do {
            let fetchRequest = type.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            fetchRequest.predicate = predicate
            
            let result = try context.fetch(fetchRequest).first as? T
            return Just(result).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            print("Read First object error: \(error)")
            return Fail(outputType: T?.self, failure: StorageException.readObjectFail).eraseToAnyPublisher()
        }
    }
    
    func readAll<T>(_ model: T.Type, predicate: NSPredicate?) -> AnyPublisher<[T], Error> where T: Storable {
        guard (model as? NSManagedObject.Type) != nil else { return Fail(error: StorageException.objectNotSupported).eraseToAnyPublisher() }
        guard let context = managedContext else { return Fail(error: StorageException.notInitialized).eraseToAnyPublisher() }
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: model.entityName)
            fetchRequest.predicate = predicate
            let results = try context.fetch(fetchRequest) as? [T] ?? []
            return Just(results).setFailureType(to: Error.self).eraseToAnyPublisher()
        } catch {
            print("Read all objects error: \(error)")
            return Fail(outputType: [T].self, failure: StorageException.readObjectFail).eraseToAnyPublisher()
        }
    }
   
}
