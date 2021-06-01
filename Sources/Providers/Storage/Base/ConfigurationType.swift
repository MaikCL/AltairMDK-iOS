//
//  ConfigurationType.swift
//  
//
//  Created by Miguel Angel on 25-05-21.
//

import Foundation

public enum ConfigurationType {
    case basic(identifier: String)
    case inMemory(identifier: String = "")
    
    func identifier() -> String {
        switch self {
            case .basic(let identifier): return identifier
            case .inMemory(let identifier): return identifier
        }
    }
}
