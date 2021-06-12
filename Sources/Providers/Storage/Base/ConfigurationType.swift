//
//  ConfigurationType.swift
//  
//
//  Created by Miguel Angel on 25-05-21.
//

import Foundation

public enum ConfigurationType {
    case basic(dbFile: URL?)
    case inMemory(identifier: String = "")
}
