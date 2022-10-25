//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public class DependencyManager {
    /// <#Description#>
    var sortedComponents: [_AnyComponent]
    /// <#Description#>
    private var dependingComponents: [DependingComponent & _AnyComponent]
    /// <#Description#>
    private var recursiveSearch: [DependingComponent & _AnyComponent] = []
    
    
    init(_ components: [_AnyComponent]) {
        sortedComponents = components.filter { !($0 is DependingComponent) }
        dependingComponents = components.compactMap { $0 as? (DependingComponent & _AnyComponent) }
        
        // Start the dependency resolution on the first component.
        if let nextComponent = dependingComponents.first {
            push(nextComponent)
        }
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - dependencyType: <#dependencyType description#>
    ///   - defaultValue: <#defaultValue description#>
    public func require<T: Component>(_ dependencyType: T.Type, defaultValue: @autoclosure () -> (T)) {
        // 1. Return if thedepending component is found in the `sortedComponents` collection.
        if sortedComponents.contains(where: { type(of: $0) is T }) {
            return
        }
        
        // 2. Search for the required component is fonud in the `dependingComponents` collection.
        // If not, use the default value calling the `defaultValue` autoclosure.
        guard let foundInDependingComponents = dependingComponents.first(where: { type(of: $0) is T }) else {
            sortedComponents.append(defaultValue())
            return
        }
        
        // Detect circles in the `recursiveSearch` collection.
        guard !recursiveSearch.contains(where: { type(of: $0) is T }) else {
            let dependencyChain = recursiveSearch
                .map { String(describing: type(of: $0)) }
                .joined(separator: ", ")
            
            guard let lastDependency = recursiveSearch.last else {
                preconditionFailure(
                    """
                    The `DependencyManager` has detected a depenency cycle of your CardinalKit components.
                    There is not last element in the `recursiveSearch` property.
                    
                    Note this precondition should never be triggered as we have entered the guard due to a
                    `contains(where: Element)` statement that returned a result.
                    It is here to trigger future failures in case this method gets refactored and to fail with a clear statement.
                    """
                )
            }
            preconditionFailure(
                """
                The `DependencyManager` has detected a depenency cycle of your CardinalKit components.
                The current dependency chain is: \(dependencyChain). The \(String(describing: type(of: lastDependency))) required a type already present in the dependency chain.
                
                Please ensure that the components you use or develop can not trigger a dependency cycle.
                """
            )
        }
        
        // If there is no cycle, resolved the dependencies of the component found in the `dependingComponents`.
        push(foundInDependingComponents)
    }
    
    /// <#Description#>
    /// - Parameter dependingComponent: <#dependingComponent description#>
    public func passedAllRequirements(_ dependingComponent: DependingComponent) {
        guard !recursiveSearch.isEmpty else {
            preconditionFailure(
                """
                A component's `dependencyResolution(_:DependencyManager)` function must only be called by a `DependencyManager`.
                The `passedAllRequirements` must only be called on the `DependencyManager` passed into
                the `dependencyResolution(_:DependencyManager)` function.
                """
            )
        }
        let component = recursiveSearch.removeLast()
        
        guard component === dependingComponent else {
            preconditionFailure(
                """
                A component's `dependencyResolution(_:DependencyManager)` function must only be called by a `DependencyManager`.
                The `passedAllRequirements` must only be called on the `DependencyManager` passed into
                the `dependencyResolution(_:DependencyManager)` function.
                """
            )
        }
        
        
        let dependingComponentsCount = dependingComponents.count
        dependingComponents.removeAll(where: { $0 === dependingComponent })
        precondition(
            dependingComponentsCount - 1 == dependingComponents.count,
            """
            Only call `passedAllRequirements` in the `dependencyResolution(_: DependencyManager)` function of your `DependingComponent`.
            """
        )
        
        guard let dependingComponent = dependingComponent as? _AnyComponent else {
            preconditionFailure(
                """
                A `DependingComponent` must also conform to `Component`.
                Please ensure that \(String(describing: type(of: dependingComponent))) conforms to `Component`.
                """
            )
        }
        
        sortedComponents.append(dependingComponent)
        
        // Call the dependency resolution mechanism on the next element in the `dependingComponents` if we are not in a recursive serach.
        if recursiveSearch.isEmpty, let nextComponent = dependingComponents.first {
            push(nextComponent)
        }
    }
    
    
    private func push(_ component: DependingComponent & _AnyComponent) {
        recursiveSearch.append(component)
        component.dependencyResolution(self)
    }
}
