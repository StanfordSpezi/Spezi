//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTRuntimeAssertions


/// A ``DependencyManager`` in Spezi is used to gather information about modules with dependencies.
public class DependencyManager {
    /// Collection of sorted modules after resolving all dependencies.
    var sortedModules: [any Module]
    /// Collection of all modules with dependencies that are not yet processed.
    private var modulesWithDependencies: [any Module]
    /// Collection used to keep track of modules with dependencies in the recursive search.
    private var searchStack: [any Module] = []


    /// A ``DependencyManager`` in Spezi is used to gather information about modules with dependencies.
    /// - Parameter module: The modules that should be resolved.
    init(_ module: [any Module]) {
        sortedModules = module.filter { $0.dependencyDeclarations.isEmpty }
        modulesWithDependencies = module.filter { !$0.dependencyDeclarations.isEmpty }
    }


    /// Resolves the dependency order.
    ///
    /// After calling `resolve` you can safely access `sortedModules`.
    func resolve() {
        // Start the dependency resolution on the first module.
        if let nextModule = modulesWithDependencies.first {
            push(nextModule)
        }

        for module in sortedModules {
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
        resolvedAllDependencies(module)
    }

    /// Communicate a requirement to a `DependencyManager`
    /// - Parameters:
    ///   - dependency: The type of the dependency that should be resolved.
    ///   - defaultValue: A default instance of the dependency that is used when the `dependencyType` is not present in the `sortedModules` or `modulesWithDependencies`.
    func require<M: Module>(_ dependency: M.Type, defaultValue: (() -> M)?) {
        // 1. Return if the depending module is found in the `sortedModules` collection.
        if sortedModules.contains(where: { type(of: $0) == M.self }) {
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
            
            guard !newModule.dependencyDeclarations.isEmpty else {
                sortedModules.append(newModule)
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
        
        // If there is no cycle, resolved the dependencies of the module found in the `dependingModules`.
        push(foundInModulesWithDependencies)
    }

    /// Retrieve a resolved dependency for a given type.
    ///
    /// - Parameters:
    ///   - module: The ``Module`` type to return.
    ///   - optional: Flag indicating if it is a optional return.
    func retrieve<M: Module>(module: M.Type = M.self, optional: Bool = false) -> M? {
        guard let module = sortedModules.first(where: { $0 is M }) as? M else {
            precondition(optional, "Could not located dependency of type \(M.self)!")
            return nil
        }

        return module
    }
    
    private func resolvedAllDependencies(_ dependingModule: any Module) {
        guard !searchStack.isEmpty else {
            preconditionFailure("Internal logic error in the `DependencyManager`")
        }
        let module = searchStack.removeLast()
        
        guard module === dependingModule else {
            preconditionFailure("Internal logic error in the `DependencyManager`")
        }
        
        
        let dependingModulesCount = modulesWithDependencies.count
        modulesWithDependencies.removeAll(where: { $0 === dependingModule })
        precondition(
            dependingModulesCount - 1 == modulesWithDependencies.count,
            "Unexpected reduction of modules. Ensure that all your modules conform to the same `Standard`"
        )
        
        sortedModules.append(dependingModule)
        
        // Call the dependency resolution mechanism on the next element in the `dependingModules` if we are not in a recursive search.
        if searchStack.isEmpty, let nextModule = modulesWithDependencies.first {
            push(nextModule)
        }
    }
}
