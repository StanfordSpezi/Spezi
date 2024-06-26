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
    private enum Storage {
        case dependency(Dependency)
        case weakDependency(WeaklyStoredModule<Dependency>)

        var value: Dependency? {
            switch self {
            case let .dependency(module):
                return module
            case let .weakDependency(reference):
                return reference.module
            }
        }
    }

    let defaultValue: (() -> Dependency)?
    private var injectedDependency: Storage?


    var isOptional: Bool {
        defaultValue == nil
    }

    var injectedDependencies: [any Module] {
        guard let injectedDependency else {
            return []
        }

        guard let module = injectedDependency.value else {
            self.injectedDependency = nil // clear the left over storage
            return []
        }

        return [module]
    }

    init(for type: Dependency.Type = Dependency.self, defaultValue: (() -> Dependency)? = nil) {
        self.defaultValue = defaultValue
    }

    func dependencyRelation(to module: any Module) -> DependencyRelation {
        let type = type(of: module)

        guard type == Dependency.self else {
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
            injectedDependency = .weakDependency(WeaklyStoredModule(dependency))
        } else {
            injectedDependency = .dependency(dependency)
        }
    }

    func uninjectDependencies(notifying spezi: Spezi) {
        let dependency = injectedDependency?.value
        injectedDependency = nil

        if let dependency {
            spezi.handleDependencyUninjection(dependency)
        }
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
        guard let dependency = injectedDependency.value as? M else {
            preconditionFailure("A injected dependency of type \(type(of: injectedDependency)) didn't match the expected type \(M.self)!")
        }
        return dependency
    }

    func retrieveOptional<M>(dependency: M.Type) -> M? {
        guard let dependency = injectedDependency?.value as? M? else {
            preconditionFailure("A injected dependency of type \(type(of: injectedDependency)) didn't match the expected type \(M?.self)!")
        }
        return dependency
    }
}
