//
//  View+Navigation.swift
//  
//
//  Created by Miguel Angel on 07-05-21.
//

import SwiftUI

extension View {

    public func onNavigation(_ action: @escaping () -> Void) -> some View {
        let isActive = Binding(
            get: { false },
            set: { newValue in
                if newValue {
                    action()
                }
            }
        )
        return NavigationLink(destination: EmptyView(), isActive: isActive) {
            self
        }
    }

    /// ### Example of use
    ///    struct ListingScene: View {
    ///        @ObservedObject private(set) var viewModel: ListingViewModel
    ///
    ///        @State private var destination: Destination?
    ///
    ///        var body: some View {
    ///            NavigationView {
    ///                VStack {
    ///                    Button("Nav") {
    ///                        destination = .detail(id: "")
    ///                    }.navigation(item: $destination, destination: viewModel.router.route(to:))
    ///                }
    ///            }
    ///            .navigationViewStyle(StackNavigationViewStyle())
    ///        }
    ///    }
    ///
    public func navigation<Item, Destination: View>(item: Binding<Item?>, @ViewBuilder destination: (Item) -> Destination) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive) {
            item.wrappedValue.map(destination)
        }
    }

    public func navigation<Destination: View>(isActive: Binding<Bool>, @ViewBuilder destination: () -> Destination) -> some View {
        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination() : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }

}

extension NavigationLink {

    public init<T: Identifiable, D: View>(item: Binding<T?>, @ViewBuilder destination: @escaping (T) -> D, @ViewBuilder label: () -> Label) where Destination == D? {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        self.init(destination: item.wrappedValue.map(destination), isActive: isActive, label: label)
    }

}
