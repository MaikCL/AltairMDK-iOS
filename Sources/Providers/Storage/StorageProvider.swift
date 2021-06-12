//
//  StorageProvider.swift
//  
//
//  Created by Miguel Angel on 25-05-21.
//

import Foundation

public protocol StorageProviderProtocol {
    var agent: StorageAgent { get }
}

public enum StorageStrategy {
    case noneStorage
    case coreData(dbFile: URL?)
}

public final class StorageProvider: StorageProviderProtocol {
    public let agent: StorageAgent

    public init(strategy: StorageStrategy) {
        do {
            switch strategy {
                case .noneStorage:
                    agent = NoneStorageAgent()
                case .coreData(let url):
                    agent = try CoreDataAgent(configuration: .basic(dbFile: url))
            }
        } catch {
            print("StorageAgent-\(String(reflecting: strategy)) initialization failed!")
            print("StorageAgent Error: \(error)")
            print("Initialization fallback NoneStorageAgent")
            agent = NoneStorageAgent()
        }
    }

}
