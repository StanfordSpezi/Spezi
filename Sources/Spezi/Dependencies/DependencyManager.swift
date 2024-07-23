//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// Gather information about modules with dependencies.
@MainActor
public class DependencyManager: Sendable {
    /// Collection of already initialized modules.
    private let existingModules: [any Module]

    /// Collection of initialized Modules.
    ///
    /// Order is determined by the dependency tree. This represents the result of the dependency resolution process.
    private(set) var initializedModules: [any Module]
    /// List of implicitly created Modules.
    ///
    /// A List of `ModuleReference`s that where implicitly created (e.g., due to another module requesting it as a Dependency and
    /// conforming to ``DefaultInitializable``).
    /// This list is important to keep for the unload mechanism.
    private(set) var implicitlyCreatedModules: Set<ModuleReference> = []

    /// Collection of all modules with dependencies that are not yet processed.
    private var modulesWithDependencies: [any Module]
    /// Recursive search stack to keep track of potential circular dependencies.
    private var searchStack: [any Module] = []


    /// A ``DependencyManager`` in Spezi is used to gather information about modules with dependencies.
    ///
    /// - Parameters:
    ///   - modules: The modules that should be resolved.
    ///   - existingModules: Collection of already initialized modules.
    init(_ modules: [any Module], existing existingModules: [any Module] = []) {
        // modules without dependencies are already considered resolved
        self.initializedModules = modules.filter { $0.dependencyDeclarations.isEmpty }

        self.modulesWithDependencies = modules.filter { !$0.dependencyDeclarations.isEmpty }

        self.existingModules = existingModules
    }


    /// Resolves the dependency order.
    ///
    /// After calling `resolve` you can safely access `initializedModules`.
    func resolve() {
        // Start the dependency resolution on the first module.
        while let nextModule = modulesWithDependencies.first {
            push(nextModule)
        }

        injectDependencies()
    }

    private func injectDependencies() {
        // We inject dependencies into existingModules as well as a new dependency might be an optional dependency from a existing module
        // that wasn't previously injected.
        for module in initializedModules + existingModules {
            for dependency in module.dependencyDeclarations {
                dependency.inject(from: self)
            }
        }
    }

    /// Push a module on the search stack and resolve dependency information.
    private func push(_ module: any Module) {
        searchStack.append(module)
        for dependency in module.dependencyDeclarations {
            dependency.collect(into: self) // leads to calls to `require(_:defaultValue:)`
        }
        finishSearch(module)
    }

    /// Communicate a requirement to a `DependencyManager`
    /// - Parameters:
    ///   - dependency: The type of the dependency that should be resolved.
    ///   - defaultValue: A default instance of the dependency that is used when the `dependencyType` is not present in the `initializedModules` or `modulesWithDependencies`.
    func require<M: Module>(_ dependency: M.Type, defaultValue: (() -> M)?) {
        // 1. Return if the depending module is found in the `initializedModules` collection.
        if initializedModules.contains(where: { type(of: $0) == M.self })
            || existingModules.contains(where: { type(of: $0) == M.self }) {
            return
        }


        // 2. Search for the required module is found in the `dependingModules` collection.
        // If not, use the default value calling the `defaultValue` auto-closure.
        guard let foundInModulesWithDependencies = modulesWithDependencies.first(where: { type(of: $0) == M.self }) else {
            guard let defaultValue else {
                // optional dependency. The user didn't supply anything. So we can't deliver anything.
                return
            }

            let newModule = defaultValue()

            implicitlyCreatedModules.insert(ModuleReference(newModule))

            guard !newModule.dependencyDeclarations.isEmpty else {
                initializedModules.append(newModule)
                return
            }
            
            modulesWithDependencies.insert(newModule, at: 0)
            push(newModule)
            
            return
        }
        
        // Detect circles in the `recursiveSearch` collection.
        guard !searchStack.contains(where: { type(of: $0) == M.self }) else {
            let dependencyChain = searchStack
                .map { String(describing: type(of: $0)) }
                .joined(separator: ", ")
            
            // The last element must exist as we entered the statement using a successful `contains` statement.
            // There is not chance to recover here: If there is a crash here, we would fail in the precondition statement in the next line anyways
            let lastElement = searchStack.last! // swiftlint:disable:this force_unwrapping
            preconditionFailure(
                """
                The `DependencyManager` has detected a dependency cycle of your Spezi modules.
                The current dependency chain is: \(dependencyChain). The \(String(describing: type(of: lastElement))) required a type already present in the dependency chain.
                
                Please ensure that the modules you use or develop can not trigger a dependency cycle.
                """
            )
        }
        
        // If there is no cycle, resolve the dependencies of the module found in the `dependingModules`.
        push(foundInModulesWithDependencies)
    }

    /// Retrieve a resolved dependency for a given type.
    ///
    /// - Parameters:
    ///   - module: The ``Module`` type to return.
    ///   - optional: Flag indicating if it is a optional return.
    /// - Returns: Returns the Module instance. Only optional, if `optional` is set to `true` and no Module was found.
    func retrieve<M: Module>(module: M.Type = M.self, optional: Bool = false) -> M? {
        guard let candidate = existingModules.first(where: { type(of: $0) == M.self })
                ?? initializedModules.first(where: { type(of: $0) == M.self }),
              let module = candidate as? M else {
            precondition(optional, "Could not located dependency of type \(M.self)!")
            return nil
        }

        return module
    }

    private func finishSearch(_ dependingModule: any Module) {
        guard !searchStack.isEmpty else {
            preconditionFailure("Internal logic error in the `DependencyManager`. Search Stack is empty.")
        }
        let module = searchStack.removeLast()

        guard module === dependingModule else {
            preconditionFailure("Internal logic error in the `DependencyManager`. Search Stack element was not the one we are resolving for.")
        }


        let dependingModulesCount = modulesWithDependencies.count
        modulesWithDependencies.removeAll(where: { $0 === dependingModule })
        precondition(
            dependingModulesCount - 1 == modulesWithDependencies.count,
            "Unexpected reduction of modules."
        )

        initializedModules.append(dependingModule)
    }
}
