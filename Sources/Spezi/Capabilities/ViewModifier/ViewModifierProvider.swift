//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


protocol ViewModifierProvider {
    var viewModifier: any ViewModifier { get }
}


extension Component {
    var viewModifiers: [any SwiftUI.ViewModifier] {
        retrieveProperties(ofType: ViewModifierProvider.self).map { provider in
            provider.viewModifier
        }
    }
}
