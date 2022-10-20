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
    var observableObjectProviders: [_AnyObservableObjectComponent] {
        storage.get(allThatConformTo: _AnyObservableObjectComponent.self)
    }
}


extension View {
    func inject(observableObjectProviders: [_AnyObservableObjectComponent]) -> some View {
        var injectedView = AnyView(self)
        for observableObjectProvider in observableObjectProviders {
            injectedView = injectedView.inject(observableObjectProvider.viewModifier)
        }
        return injectedView
    }
    
    private func inject<M: ViewModifier>(_ modifier: M) -> AnyView {
        AnyView(self.modifier(modifier))
    }
}
