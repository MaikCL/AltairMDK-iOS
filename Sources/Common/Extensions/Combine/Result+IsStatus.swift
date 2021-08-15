//
//  Result+IsStatus.swift
//  
//
//  Created by Miguel Angel on 08-08-21.
//

import Combine

extension Result {
    
    public var isSuccess: Bool {
        switch self {
            case .success: return true
            default: return false
        }
    }
    
    public var isFailure: Bool {
        switch self {
            case .failure: return true
            default: return false
        }
    }
}
