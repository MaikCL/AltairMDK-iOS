//
//  Publisher+NoRetain.swift
//  
//
//  Created by Miguel Angel on 10-05-21.
//

import Combine

extension Publisher where Self.Failure == Never {
    
    /// ### Example of use
    ///        store
    ///            .$state
    ///            .map { $0.exception }
    ///            .receive(on: DispatchQueue.main)
    ///            .assignNoRetain(to: \.exception, on: self)
    ///            .store(in: &bag)
    ///
    func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath< Root,
        Self.Output >, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
}
