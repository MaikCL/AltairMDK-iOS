//
//  CoreDataAgent.swift
//  
//
//  Created by Miguel Angel on 01-06-21.
//

import Combine
import CoreData

final class CoreDataAgent {
    
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
}
