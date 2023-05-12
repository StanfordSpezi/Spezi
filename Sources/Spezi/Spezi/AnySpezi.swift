//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os


/// Type-erased version of a ``Spezi`` instance used internally in Spezi.
protocol AnySpezi {
    /// A typesafe typedCollection of different elements of an ``Spezi/Spezi`` instance.
    var typedCollection: TypedCollection { get }
    /// Logger used to log events in the ``Spezi/Spezi`` instance.
    var logger: Logger { get }
}
