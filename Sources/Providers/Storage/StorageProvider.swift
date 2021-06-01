//
//  StorageProvider.swift
//  
//
//  Created by Miguel Angel on 25-05-21.
//

public protocol StorageProviderProtocol {
    var agent: StorageAgent { get }
}

public enum StorageStrategy {
    case noneStorage
    case coreData
}

public final class StorageProvider: StorageProviderProtocol {
    public let agent: StorageAgent

    public init(strategy: StorageStrategy) {
        do {
            switch strategy {
                case .noneStorage:
                    agent = NoneStorageAgent()
                case .coreData:
                    agent = try CoreDataAgent(configuration: .basic(identifier: "agregar la wea"))
            }
        } catch {
            print("StorageAgent-\(String(reflecting: strategy)) initialization failed!")
            print("StorageAgent Error: \(error)")
            print("Initialization fallback NoneStorageAgent")
            agent = NoneStorageAgent()
        }
    }

}