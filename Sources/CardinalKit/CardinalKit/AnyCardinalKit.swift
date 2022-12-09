//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os


/// Type-erased version of a ``CardinalKit`` instance used internally in CardinalKit.
protocol AnyCardinalKit {
    /// A typesafe typedCollection of different elements of an ``CardinalKit/CardinalKit`` instance.
    var typedCollection: TypedCollection { get }
    /// Logger used to log events in the ``CardinalKit/CardinalKit`` instance.
    var logger: Logger { get }
}
