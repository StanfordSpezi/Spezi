//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Spezi {
    /// Access the global Spezi instance.
    ///
    /// Access the global Spezi instance using the ``Module/Application`` property wrapper inside your ``Module``.
    ///
    /// Below is a short code example on how to access the Spezi instance.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Application(\.spezi)
    ///     var spezi
    /// }
    /// ```
    public var spezi: Spezi {
        // this seems nonsensical, but is essential to support Spezi access from the @Application modifier
        self
    }
}
