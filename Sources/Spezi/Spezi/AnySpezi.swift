//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import SpeziFoundation
import SwiftUI


/// Type-erased version of a ``Spezi`` instance used internally in Spezi.
protocol AnySpezi {
    /// A shared repository to store any ``KnowledgeSource``s restricted to the ``SpeziAnchor``.
    var storage: SpeziStorage { get }
    /// Logger used to log events in the ``Spezi/Spezi`` instance.
    var logger: Logger { get }
    /// Array of all SwiftUI `ViewModifiers` collected using ``_ModifierPropertyWrapper`` from the configured ``Module``s.
    var viewModifiers: [any ViewModifier] { get }
}
