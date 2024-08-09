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
    /// Directly access the injected dependency of the dependency declaration.
    ///
    /// Unsafe, as there are not extra checks made to guarantee a safe value.
    var unsafeInjectedModules: [any Module] { get }

    /// Request from the ``DependencyManager`` to collect all dependencies. Mark required by calling `DependencyManager/require(_:defaultValue:)`.
    @MainActor
    func collect(into dependencyManager: DependencyManager)
    /// Inject the dependency instance from the ``DependencyManager``. Use `DependencyManager/retrieve(module:)`.
    /// - Parameters:
    ///   - dependencyManager: The dependency manager to inject the dependencies from.
    ///   - module: The module where the dependency declaration is located at.
    @MainActor
    func inject(from dependencyManager: DependencyManager, for module: any Module)

    @MainActor
    func inject(spezi: Spezi)

    /// Remove all dependency injections.
    @MainActor
    func uninjectDependencies(notifying spezi: Spezi)

    /// Same as `uninjectDependencies` but called from the non-isolated deinit
    func nonIsolatedUninjectDependencies(notifying spezi: Spezi)

    /// Determine the dependency relationship to a given module.
    /// - Parameter module: The module to retrieve the dependency relationship for.
    /// - Returns: Returns the `DependencyRelation`
    func dependencyRelation(to module: DependencyReference) -> DependencyRelation
}


extension Module {
    var dependencyDeclarations: [DependencyDeclaration] {
        retrieveProperties(ofType: DependencyDeclaration.self)
    }
}
