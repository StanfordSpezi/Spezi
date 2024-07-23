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
    private weak var spezi: Spezi?
    private var injectedDependency: DynamicReference<Dependency>?


    var isOptional: Bool {
        defaultValue == nil
    }

    private var dependency: Dependency? {
        guard let injectedDependency else {
            return nil
        }

        if let module = injectedDependency.element {
            return module
        }

        // Otherwise, we have a weakly injected module that was de-initialized.
        // See, if there are multiple modules of the same type and inject the "next" one.
        if let replacement = spezi?.retrieveDependencyReplacement(for: Dependency.self) {
            self.injectedDependency = .weakElement(replacement) // update injected dependency
            return replacement
        }

        // clear the left over storage
        self.injectedDependency = nil
        return nil
    }

    init(for type: Dependency.Type = Dependency.self, defaultValue: (() -> Dependency)? = nil) {
        self.defaultValue = defaultValue
    }

    func dependencyRelation(to module: DependencyReference) -> DependencyRelation {
        guard module.sameType(as: Dependency.self) else {
            return .unrelated
        }

        if isOptional {
            return .optional
        } else {
            return .dependent
        }
    }

    func collect(into dependencyManager: DependencyManager) {
        dependencyManager.require(Dependency.self, defaultValue: defaultValue)
    }

    func inject(from dependencyManager: DependencyManager) {
        guard let dependency = dependencyManager.retrieve(module: Dependency.self, optional: isOptional) else {
            injectedDependency = nil
            return
        }

        if isOptional {
            injectedDependency = .weakElement(dependency)
        } else {
            injectedDependency = .element(dependency)
        }
    }

    func inject(spezi: Spezi) {
        self.spezi = spezi
    }

    func uninjectDependencies(notifying spezi: Spezi) {
        let dependency = injectedDependency?.element
        injectedDependency = nil

        if let dependency {
            spezi.handleDependencyUninjection(of: dependency)
        }
    }

    func nonIsolatedUninjectDependencies(notifying spezi: Spezi) {
        let injectedDependency = injectedDependency
        self.injectedDependency = nil

        if let injectedDependency {
            Task { @MainActor in
                guard let dependency = injectedDependency.element else {
                    return
                }
                spezi.handleDependencyUninjection(of: dependency)
            }
        }
    }

    func retrieve<M>(dependency dependencyType: M.Type) -> M {
        guard let dependency else {
            preconditionFailure(
                """
                A `@Dependency` was accessed before the dependency was activated. \
                Only access dependencies once the module has been configured and the Spezi initialization is complete.
                """
            )
        }
        guard let dependencyM = dependency as? M else {
            preconditionFailure("A injected dependency of type \(type(of: injectedDependency)) didn't match the expected type \(M.self)!")
        }
        return dependencyM
    }

    func retrieveOptional<M>(dependency: M.Type) -> M? {
        guard let dependency = self.dependency as? M? else {
            preconditionFailure("A injected dependency of type \(type(of: injectedDependency)) didn't match the expected type \(M?.self)!")
        }
        return dependency
    }
}
