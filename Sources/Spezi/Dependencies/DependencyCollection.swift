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
