//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// An adopter of this protocol is a property of a ``Module`` that provides a SwiftUI
/// `ViewModifier` to be injected into the global view hierarchy.
protocol ViewModifierProvider {
    /// The view modifier instance that should be injected into the SwiftUI view hierarchy.
    var viewModifier: any ViewModifier { get }
}


extension Module {
    /// All SwiftUI `ViewModifier` the module wants to modify the global view hierarchy with.
    var viewModifiers: [any SwiftUI.ViewModifier] {
        retrieveProperties(ofType: ViewModifierProvider.self).map { provider in
            provider.viewModifier
        }
    }
}
