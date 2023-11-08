//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Provides mechanism to communicate dependency requirements.
///
/// This protocol allows to communicate dependency requirements of a ``Module`` to the ``DependencyManager``.
protocol DependencyDeclaration {
    /// Request from the ``DependencyManager`` to collect all dependencies. Mark required by calling `DependencyManager/require(_:defaultValue:)`.
    func collect(into dependencyManager: DependencyManager)
    /// Inject the dependency instance from the ``DependencyManager``. Use `DependencyManager/retrieve(module:)`.
    func inject(from dependencyManager: DependencyManager)
}

extension Module {
    var dependencyDeclarations: [DependencyDeclaration] {
        retrieveProperties(ofType: DependencyDeclaration.self)
    }
}
