//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct WrappedViewModifier<Modifier: ViewModifier>: ViewModifierInitialization, @unchecked Sendable {
    // @uncheked Sendable is fine as we are never allowing to mutate the non-Sendable `Model` till it arrives on the MainActor.
    // ViewModifiers must be instantiated on the MainActor and `initializedModifier()` will only release the Modifier once it arrives on the MainActor.
    // So this is essentially just a storage to pass around the Modifier between different actors but guarantees that it never leaves the MainActor.
    private let modifier: Modifier

    init(modifier: Modifier) {
        self.modifier = modifier
    }

    func initializeModifier() -> Modifier {
        modifier
    }
}
