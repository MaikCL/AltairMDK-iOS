//
//  SheetModifier.swift
//  
//
//  Created by Miguel Angel on 07-05-21.
//

import SwiftUI

public struct SheetModifier<Item: Identifiable, Destination: View>: ViewModifier {

    // MARK: Stored Properties

    private let item: Binding<Item?>
    private let destination: (Item) -> Destination

    // MARK: Initialization

    public init(item: Binding<Item?>, @ViewBuilder content: @escaping (Item) -> Destination) {
        self.item = item
        self.destination = content
    }

    // MARK: Methods

    public func body(content: Content) -> some View {
        content.sheet(item: item, content: destination)
    }

}
