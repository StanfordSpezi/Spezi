//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


protocol ObservableObjectProvider {
    var modifier: any ViewModifier { get }
}


extension AnyCardinalKit {
    /// A collection of ``CardinalKit/CardinalKit`` `LifecycleHandler`s.
    var observableObjectProviders: [ObservableObjectProvider] {
        get async {
            await storage.get(allThatConformTo: ObservableObjectProvider.self)
        }
    }
}


extension View {
    func inject(observableObjectProviders: [ObservableObjectProvider]) -> some View {
        var injectedView = AnyView(self)
        for observableObjectProvider in observableObjectProviders {
            injectedView = injectedView.inject(observableObjectProvider.modifier)
        }
        return injectedView
    }
    
    private func inject<M: ViewModifier>(_ modifier: M) -> AnyView {
        AnyView(self.modifier(modifier))
    }
}
