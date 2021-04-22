//
//  Created by Miguel Angel on 01-04-21.
//

import SwiftUI

extension Binding {
    
    /// ### Example of use
    ///     struct ContentView: View {
    ///         @State private var name = ""
    ///
    ///         var body: some View {
    ///             TextField("Enter name:", text: $name.onChange(nameChanged))
    ///         }
    ///
    ///         func nameChanged(to value: String) {
    ///             print("Name changed to \(name)!")
    ///         }
    ///     }
    ///
    public func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: {
                self.wrappedValue
            },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
        })
    }
}
