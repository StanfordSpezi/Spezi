//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A collection of dependency declarations.
public struct DependencyCollection: DependencyDeclaration {
    let entries: [AnyDependencyContext]


    init(_ entries: [AnyDependencyContext]) {
        self.entries = entries
    }

    init(_ entries: AnyDependencyContext...) {
        self.init(entries)
    }
    
    /// Creates a ``DependencyCollection`` from a closure resulting in a single generic type conforming to the Spezi  ``Module``.
    /// - Parameters:
    ///   - type: The generic type resulting from the passed closure, has to conform to ``Module``.
    ///   - singleEntry: Closure returning a dependency conforming to ``Module``, stored within the ``DependencyCollection``.
    ///
    /// ### Usage
    ///
    /// The `SomeCustomDependencyBuilder` enforces certain type constraints (e.g., `SomeTypeConstraint`, more specific than ``Module``) during aggregation of ``Module/Dependency``s (``Module``s)  via a result builder.
    /// The individual dependency expressions within the result builder conforming to `SomeTypeConstraint` are then transformed to a ``DependencyCollection`` via ``DependencyCollection/init(for:singleEntry:)``.
    ///
    /// ```swift
    /// @resultBuilder
    /// public enum SomeCustomDependencyBuilder: DependencyCollectionBuilder {
    ///     public static func buildExpression<T: SomeTypeConstraint>(_ expression: @escaping @autoclosure () -> T) -> DependencyCollection {
    ///         DependencyCollection(singleEntry: expression)
    ///     }
    /// }
    /// ```
    ///
    /// See `_DependencyPropertyWrapper/init(using:)` for a continued example regarding the usage of the implemented result builder.
    public init<Dependency: Module>(for type: Dependency.Type = Dependency.self, singleEntry: @escaping (() -> Dependency)) {
        self.init(DependencyContext(for: type, defaultValue: singleEntry))
    }


    func collect(into dependencyManager: DependencyManager) {
        for entry in entries {
            entry.collect(into: dependencyManager)
        }
    }

    func inject(from dependencyManager: DependencyManager) {
        for entry in entries {
            entry.inject(from: dependencyManager)
        }
    }

    private func singleDependencyContext() -> AnyDependencyContext {
        guard let dependency = entries.first else {
            preconditionFailure("DependencyCollection unexpectedly empty!")
        }
        precondition(entries.count == 1, "Expected exactly one element in the dependency collection!")
        return dependency
    }

    func singleDependencyRetrieval<M>(for module: M.Type = M.self) -> M {
        singleDependencyContext().retrieve(dependency: M.self)
    }

    func singleOptionalDependencyRetrieval<M>(for module: M.Type = M.self) -> M? {
        singleDependencyContext().retrieveOptional(dependency: M.self)
    }

    func retrieveModules() -> [any Module] {
        entries.map { dependency in
            dependency.retrieve(dependency: (any Module).self)
        }
    }
}
