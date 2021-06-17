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
    case coreData(dbFile: URL?)
}

public final class StorageProvider: StorageProviderProtocol {
    public let agent: StorageAgent

    public init(strategy: StorageStrategy) {
        switch strategy {
            case .coreData(let url):
                agent = CoreDataAgent(configuration: .basic(dbFile: url))
        }
    }

}
