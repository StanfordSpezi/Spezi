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
    private var recursiveSearch: [any Module] = []
    
    
    /// A ``DependencyManager`` in Spezi is used to gather information about modules with dependencies.
    /// - Parameter module: The modules that should be resolved.
    init(_ module: [any Module]) {
        sortedModules = module.filter { $0.dependencyDescriptors.isEmpty }
        modulesWithDependencies = module.filter { !$0.dependencyDescriptors.isEmpty }
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
            for dependency in module.dependencyDescriptors {
                dependency.inject(dependencyManager: self)
            }
        }
    }
    
    /// Injects a dependency into a `_DependencyPropertyWrapper` that is resolved in the `sortedModules`.
    /// - Parameters:
    ///   - dependencyType: The type of the dependency that should be injected.
    ///   - anyDependency: The ``ModuleDependency`` that the provided dependency should be injected into.
    func inject<D: ModuleDependency>(
        _ dependencyType: D.ModuleType.Type,
        into anyDependency: D
    ) {
        guard let foundInSortedModuless = sortedModules.first(where: { type(of: $0) == D.ModuleType.self }) as? D.ModuleType else {
            preconditionFailure("Could not find the injectable module in the `sortedModules`.")
        }
        
        anyDependency.inject(dependency: foundInSortedModuless)
    }
    
    /// Communicate a requirement to a `DependencyManager`
    /// - Parameters:
    ///   - dependencyType: The type of the dependency that should be resolved.
    ///   - defaultValue: A default instance of the dependency that is used when the `dependencyType` is not present in the `sortedModules` or `modulesWithDependencies`.
    func require<M: Module>(_ dependencyType: M.Type, defaultValue: @autoclosure () -> M) {
        // 1. Return if the depending module is found in the `sortedModules` collection.
        if sortedModules.contains(where: { type(of: $0) == M.self }) {
            return
        }
        
        // 2. Search for the required module is found in the `dependingModules` collection.
        // If not, use the default value calling the `defaultValue` autoclosure.
        guard let foundInModulesWithDependencies = modulesWithDependencies.first(where: { type(of: $0) == M.self }) else {
            let newModule = defaultValue()
            
            guard !newModule.dependencyDescriptors.isEmpty else {
                sortedModules.append(newModule)
                return
            }
            
            modulesWithDependencies.insert(newModule, at: 0)
            push(newModule)
            
            return
        }
        
        // Detect circles in the `recursiveSearch` collection.
        guard !recursiveSearch.contains(where: { type(of: $0) == M.self }) else {
            let dependencyChain = recursiveSearch
                .map { String(describing: type(of: $0)) }
                .joined(separator: ", ")
            
            // The last element must exist as we entered the statement using a successful `contains` statement.
            // There is not chance to recover here: If there is a crash here, we would fail in the precondition statement in the next line anyways
            let lastElement = recursiveSearch.last! // swiftlint:disable:this force_unwrapping
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
    
    private func resolvedAllDependencies(_ dependingModule: any Module) {
        guard !recursiveSearch.isEmpty else {
            preconditionFailure("Internal logic error in the `DependencyManager`")
        }
        let module = recursiveSearch.removeLast()
        
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
        if recursiveSearch.isEmpty, let nextModule = modulesWithDependencies.first {
            push(nextModule)
        }
    }
    
    
    private func push(_ module: any Module) {
        recursiveSearch.append(module)
        for dependency in module.dependencyDescriptors {
            dependency.gatherDependency(dependencyManager: self)
        }
        resolvedAllDependencies(module)
    }
}
