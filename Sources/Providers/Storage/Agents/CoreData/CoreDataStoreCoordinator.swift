//
//  CoreDataStoreCoordinator.swift
//  
//
//  Created by Miguel Angel on 31-05-21.
//

import CoreData

enum StoreType: String {
    case sqLiteStoreType
    case inMemoryStoreType
}

class CoreDataStoreCoordinator {
    
    static func persistentStoreCoordinator(urlModel: URL?, storeType: StoreType) throws -> NSPersistentStoreCoordinator {
        return try NSPersistentStoreCoordinator.coordinator(urlModel: urlModel, storeType: storeType)
    }
    
}

private extension NSPersistentStoreCoordinator {
    
    static func coordinator(urlModel: URL?, storeType: StoreType) throws -> NSPersistentStoreCoordinator {
        guard let dbModel = urlModel else {
            throw StorageException.dbModelFileNotFound
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: dbModel) else {
            throw StorageException.dbModelCreationFail
        }
        
        let persistentContainer = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        switch storeType {
            case .sqLiteStoreType:
                try persistentContainer.configureSQLiteStore(name: dbModel.deletingPathExtension().lastPathComponent)
            case .inMemoryStoreType:
                try persistentContainer.configureInMemoryStore()
        }
        return persistentContainer
    }
    
}

private extension NSPersistentStoreCoordinator {
    
    func configureSQLiteStore(name: String) throws {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            throw StorageException.storePathNotFound
        }
        
        do {
            let url = documents.appendingPathComponent("\(name).sqlite")
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            try addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            throw StorageException.unknown(error)
        }
    }
    
    func configureInMemoryStore() throws {
        var memoryStoreError: Error? = .none
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        self.addPersistentStore(with: description) { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            if let error = error {
                memoryStoreError = error
                print("Create an in-mem coordinator failed \(error)")
            }
        }
        
        if let error = memoryStoreError {
            throw StorageException.unknown(error)
        }
        
    }
    
}

