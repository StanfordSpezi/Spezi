//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A collection of dependencies.
///
/// This collection contains a collection of Modules that are meant to be declared as the dependencies of another module.
///
/// The code example below demonstrates how you can easily create your collection of dependencies from multiple different types of ``Module``s.
///
/// - Tip: You can also use ``append(contentsOf:)`` to combine two collections.
///
/// ```swift
/// var collection = DependencyCollection(ModuleA(), ModuleB(), ModuleC())
///
/// collection.append(ModuleD())
/// ```
///
/// - Note: Use the ``DependencyCollectionBuilder`` if you want to create your own result builder that can build a ``DependencyCollection`` component
///     out of multiple `Module` expressions.
public struct DependencyCollection {
    private var entries: [AnyDependencyContext]

    /// Determine if the collection is empty.
    public var isEmpty: Bool {
        entries.isEmpty
    }

    /// The count of entries.
    public var count: Int {
        entries.count
    }

    init(_ entries: [AnyDependencyContext]) {
        self.entries = entries
    }

    init(_ entries: AnyDependencyContext...) {
        self.init(entries)
    }

    /// Create an empty collection.
    public init() {
        self.entries = []
    }


    /// Create a collection with entries
    ///
    /// - Note: You can create your own result builders that build a `DependencyCollection` using the ``DependencyCollectionBuilder``.
    ///
    /// - Parameter entry: The parameter pack of modules.
    public init<each M: Module>(_ entry: repeat each M) {
        self.init()
        repeat append(each entry)
    }

    /// Create a collection from a single entry closure.
    ///
    /// - Note: You can create your own result builders that build a `DependencyCollection` using the ``DependencyCollectionBuilder``.
    ///
    /// - Parameters:
    ///   - type: The generic type resulting from the passed closure, has to conform to ``Module``.
    ///   - singleEntry: Closure returning a dependency conforming to ``Module``, stored within the ``DependencyCollection``.
    @available(
        *, deprecated, renamed: "init(_:)",
        message: "DependencyCollection entries are now always an explicit request to load and do not require a closure anymore."
    )
    public init<Dependency: Module>(for type: Dependency.Type = Dependency.self, singleEntry: @escaping (() -> Dependency)) {
        self.init(singleEntry())
    }

    /// Create a collection from a single entry closure.
    ///
    /// - Note: You can create your own result builders that build a `DependencyCollection` using the ``DependencyCollectionBuilder``.
    ///
    /// - Parameters:
    ///   - type: The generic type resulting from the passed closure, has to conform to ``Module``.
    ///   - singleEntry: Closure returning a dependency conforming to ``Module``, stored within the ``DependencyCollection``.
    @available(
        *, deprecated, renamed: "init(_:)",
         message: "DependencyCollection entries are now always an explicit request to load and do not require a closure anymore."
    )
    public init<Dependency: Module>(for type: Dependency.Type = Dependency.self, singleEntry: @escaping @autoclosure (() -> Dependency)) {
        self.init(singleEntry())
    }


    /// Append a collection.
    /// - Parameter collection: The dependency collection to append to this one.
    public mutating func append(contentsOf collection: DependencyCollection) {
        entries.append(contentsOf: collection.entries)
    }


    /// Append a module.
    /// - Parameter module: The ``Module`` to append to the collection.
    public mutating func append<M: Module>(_ module: M) {
        // we always treat modules passed to a Dependency collection as an explicit request to load them, therefore .load
        entries.append(DependencyContext(for: M.self, type: .load, defaultValue: { module }))
    }
}


extension DependencyCollection: DependencyDeclaration {
    var unsafeInjectedModules: [any Module] {
        entries.flatMap { entry in
            entry.unsafeInjectedModules
        }
    }
    
    func dependencyRelation(to module: DependencyReference) -> DependencyRelation {
        let relations = entries.map { $0.dependencyRelation(to: module) }

        if relations.contains(.dependent) {
            return .dependent
        } else if relations.contains(.optional) {
            return .optional
        } else {
            return .unrelated
        }
    }


    func collect(into dependencyManager: DependencyManager) throws(DependencyManagerError) {
        for entry in entries {
            try entry.collect(into: dependencyManager)
        }
    }

    func inject(from dependencyManager: DependencyManager, for module: any Module) throws(DependencyManagerError) {
        for entry in entries {
            try entry.inject(from: dependencyManager, for: module)
        }
    }

    func inject(spezi: Spezi) {
        for entry in entries {
            entry.inject(spezi: spezi)
        }
    }

    func uninjectDependencies(notifying spezi: Spezi) {
        for entry in entries {
            entry.uninjectDependencies(notifying: spezi)
        }
    }

    func nonIsolatedUninjectDependencies(notifying spezi: Spezi) {
        for entry in entries {
            entry.nonIsolatedUninjectDependencies(notifying: spezi)
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
