//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DependencyManager`` in CardinalKit is used to gather information about dependencies of a ``DependingComponent``.
public class _DependencyManager { // swiftlint:disable:this type_name
    // We want the _DependencyManager type to be hidden from autocompletion and document generation.
    // Therefore, we use the `_` prefix.
    /// Collection of sorted components after resolving all dependencies.
    var sortedComponents: [_AnyComponent]
    /// Collection of all ``DependingComponent``s that are not yet processed.
    private var dependingComponents: [any DependingComponent & _AnyComponent]
    /// Collection used to keep track of ``DependingComponent``s in the recursive search.
    private var recursiveSearch: [any DependingComponent & _AnyComponent] = []
    
    
    init(_ components: [_AnyComponent]) {
        sortedComponents = components.filter { !($0 is (any DependingComponent)) }
        dependingComponents = components.compactMap { $0 as? (any DependingComponent & _AnyComponent) }
        
        // Start the dependency resolution on the first component.
        if let nextComponent = dependingComponents.first {
            push(nextComponent)
        }
    }
    
    
    func require<T: Component>(_ dependencyType: T.Type, defaultValue: @autoclosure () -> (T)) {
        // 1. Return if thedepending component is found in the `sortedComponents` collection.
        if sortedComponents.contains(where: { type(of: $0) == T.self }) {
            return
        }
        
        // 2. Search for the required component is found in the `dependingComponents` collection.
        // If not, use the default value calling the `defaultValue` autoclosure.
        guard let foundInDependingComponents = dependingComponents.first(where: { type(of: $0) == T.self }) else {
            let newComponent = defaultValue()
            
            guard let newDependingComponent = newComponent as? (any DependingComponent & _AnyComponent) else {
                sortedComponents.append(newComponent)
                return
            }
            
            dependingComponents.insert(newDependingComponent, at: 0)
            push(newDependingComponent)
            
            return
        }
        
        // Detect circles in the `recursiveSearch` collection.
        guard !recursiveSearch.contains(where: { type(of: $0) == T.self }) else {
            let dependencyChain = recursiveSearch
                .map { String(describing: type(of: $0)) }
                .joined(separator: ", ")
            
            // The last element must exist as we entered the statement using a successful `contains` statement.
            // There is not chance to recover here: If there is a crash here, we would fail in the precondition statement in the next line anyways
            let lastElement = recursiveSearch.last! // swiftlint:disable:this force_unwrapping
            precondition(
                false, // Nescessary to call our version of the `precondition` function to use this in unit testing.
                """
                The `DependencyManager` has detected a depenency cycle of your CardinalKit components.
                The current dependency chain is: \(dependencyChain). The \(String(describing: type(of: lastElement))) required a type already present in the dependency chain.
                
                Please ensure that the components you use or develop can not trigger a dependency cycle.
                """
            )
            return
        }
        
        // If there is no cycle, resolved the dependencies of the component found in the `dependingComponents`.
        push(foundInDependingComponents)
    }
    
    private func resolvedAllDependencies(_ dependingComponent: any DependingComponent) {
        guard !recursiveSearch.isEmpty else {
            precondition(false, "Internal logic error in the `DependencyManager`")
            return
        }
        let component = recursiveSearch.removeLast()
        
        guard component === dependingComponent else {
            precondition(false, "Internal logic error in the `DependencyManager`")
            return
        }
        
        
        let dependingComponentsCount = dependingComponents.count
        dependingComponents.removeAll(where: { $0 === dependingComponent })
        precondition(
            dependingComponentsCount - 1 == dependingComponents.count,
            """
            Only call `passedAllRequirements` in the `dependencyResolution(_: DependencyManager)` function of your `DependingComponent`.
            """
        )
        
        sortedComponents.append(dependingComponent)
        
        // Call the dependency resolution mechanism on the next element in the `dependingComponents` if we are not in a recursive serach.
        if recursiveSearch.isEmpty, let nextComponent = dependingComponents.first {
            push(nextComponent)
        }
    }
    
    
    private func push(_ component: any DependingComponent & _AnyComponent) {
        recursiveSearch.append(component)
        for dependency in component.dependencies {
            dependency._visit(dependencyManager: self)
        }
        resolvedAllDependencies(component)
    }
}
