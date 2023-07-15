//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


extension AnySpezi {
    /// A collection of ``Spezi/Spezi`` `LifecycleHandler`s.
    var observableObjectProviders: [any ObservableObjectProvider] {
        storage.collect(allOf: (any ObservableObjectProvider).self)
    }
}


extension View {
    func inject(observableObjectProviders: [any ObservableObjectProvider]) -> some View {
        var injectedView = AnyView(self)
        for observableObjectProvider in observableObjectProviders {
            injectedView = observableObjectProvider.inject(in: injectedView)
        }
        return injectedView
    }
}
