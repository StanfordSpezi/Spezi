//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import OrderedCollections
import SwiftUI


enum ModifierPlacement: Int, Comparable {
    /// No specific order requirement.
    case regular
    /// Outermost placement (e.g., @Model-based property wrappers).
    case outermost

    static func < (lhs: ModifierPlacement, rhs: ModifierPlacement) -> Bool {
        lhs == .regular && rhs == .outermost
    }
}


/// An adopter of this protocol is a property of a ``Module`` that provides a SwiftUI
/// [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier) to be injected into the global view hierarchy.
protocol ViewModifierProvider {
    /// The persistent identifier for the view modifier provider.
    var id: UUID { get }

    /// The view modifier instance that should be injected into the SwiftUI view hierarchy.
    ///
    /// Does nothing if `nil` is provided.
    @MainActor var viewModifier: (any ViewModifier)? { get }

    /// Defines the placement order of this view modifier.
    ///
    /// `ViewModifier`s retrieved from a ``Module`` might modify the view hierarchy in a different order than they
    /// are supplied. This is important to, e.g., ensure that modifiers injecting model types are placed at the outermost
    /// level to ensure other view modifiers supplied by the module can access those model types.
    var placement: ModifierPlacement { get }
}


extension ViewModifierProvider {
    var placement: ModifierPlacement {
        .regular
    }
}


extension Module {
    /// All SwiftUI `ViewModifier` the module wants to modify the global view hierarchy with.
    @MainActor
    var viewModifierEntires: [(UUID, any ViewModifier)] {
        retrieveProperties(ofType: (any ViewModifierProvider).self)
            .sorted { lhs, rhs in
                lhs.placement < rhs.placement
            }
            .compactMap { provider in
                guard let modifier = provider.viewModifier else {
                    return nil
                }
                return (provider.id, modifier)
            }
    }
}
