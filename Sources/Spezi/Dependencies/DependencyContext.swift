//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


protocol AnyDependencyContext: DependencyDeclaration {
    func retrieve<M>(dependency: M.Type) -> M

    func retrieveOptional<M>(dependency: M.Type) -> M?
}


class DependencyContext<Dependency: Module>: AnyDependencyContext {
    let defaultValue: (() -> Dependency)?
    private var injectedDependency: Dependency?

    init(for type: Dependency.Type = Dependency.self, defaultValue: (() -> Dependency)? = nil) {
        self.defaultValue = defaultValue
    }

    func collect(into dependencyManager: DependencyManager) {
        dependencyManager.require(Dependency.self, defaultValue: defaultValue)
    }

    func inject(from dependencyManager: DependencyManager) {
        precondition(injectedDependency == nil, "Dependency of type \(Dependency.self) is already injected!")
        injectedDependency = dependencyManager.retrieve(optional: defaultValue == nil)
    }

    func retrieve<M>(dependency: M.Type) -> M {
        guard let injectedDependency else {
            preconditionFailure(
                """
                A `@Dependency` was accessed before the dependency was activated. \
                Only access dependencies once the module has been configured and the Spezi initialization is complete.
                """
            )
        }
        guard let dependency = injectedDependency as? M else {
            preconditionFailure("A injected dependency of type \(type(of: injectedDependency)) didn't match the expected type \(M.self)!")
        }
        return dependency
    }

    func retrieveOptional<M>(dependency: M.Type) -> M? {
        guard let dependency = injectedDependency as? M? else {
            preconditionFailure("A injected dependency of type \(type(of: injectedDependency)) didn't match the expected type \(M?.self)!")
        }
        return dependency
    }
}
