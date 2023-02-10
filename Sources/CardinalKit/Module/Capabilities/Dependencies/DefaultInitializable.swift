//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// ``DefaultInitializable`` is used to identify ``Component``s that can be initialized without the need for additional context.
public protocol DefaultInitializable {
    /// A default initializer with no arguments provided by conforming to ``DefaultInitializable``
    init()
}
