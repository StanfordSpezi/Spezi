//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


extension AnyCardinalKit {
    /// A collection of ``CardinalKit/CardinalKit`` `LifecycleHandler`s.
    var observableObjectProviders: [any ObservableObjectComponent] {
        typedCollection.get(allThatConformTo: (any ObservableObjectComponent).self)
    }
}


extension View {
    func inject(observableObjectProviders: [any ObservableObjectComponent]) -> some View {
        var injectedView = AnyView(self)
        for observableObjectProvider in observableObjectProviders {
            injectedView = injectedView.inject(observableObjectProvider.viewModifier)
        }
        return injectedView
    }
    
    private func inject(_ modifier: some ViewModifier) -> AnyView {
        AnyView(self.modifier(modifier))
    }
}
