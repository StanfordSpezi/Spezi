//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// The relationship of given `Module` to another `Module`.
enum DependencyRelation: Hashable {
    /// The given module is a dependency of the other module.
    case dependent
    /// The given module is an optional dependency of the other module.
    case optional
    /// The given module is not a dependency of the other module.
    case unrelated
}


/// Provides mechanism to communicate dependency requirements.
///
/// This protocol allows to communicate dependency requirements of a ``Module`` to the ``DependencyManager``.
protocol DependencyDeclaration {
    /// List of injected dependencies.
    var injectedDependencies: [any Module] { get }

    /// Request from the ``DependencyManager`` to collect all dependencies. Mark required by calling `DependencyManager/require(_:defaultValue:)`.
    func collect(into dependencyManager: DependencyManager)
    /// Inject the dependency instance from the ``DependencyManager``. Use `DependencyManager/retrieve(module:)`.
    func inject(from dependencyManager: DependencyManager)

    /// Remove all dependency injections.
    func uninjectDependencies(notifying spezi: Spezi)

    /// Determine the dependency relationship to a given module.
    /// - Parameter module: The module to retrieve the dependency relationship for.
    /// - Returns: Returns the `DependencyRelation`
    func dependencyRelation(to module: any Module) -> DependencyRelation
}


extension Module {
    var dependencyDeclarations: [DependencyDeclaration] {
        retrieveProperties(ofType: DependencyDeclaration.self)
    }
}
