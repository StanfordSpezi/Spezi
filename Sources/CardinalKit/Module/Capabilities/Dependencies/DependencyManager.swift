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
        
        // `passedAllRequirements` then calls the dependency resolution mechanism on the next element in the `dependingComponents`.
        dependingComponents.first?.dependencyResolution(self)
    }
    
    
    func require<T: Component>(_ type: T.Type, defaultValue: @autoclosure () -> (T)) {
        #warning(
            """
            TODO:
            1. Ensure that all components dependend are found in the sortedComponents type.
            2. If not, search the dependingComponents for the component.
                - If present, push it on the recursiveSearch stack and start the resolution for this component.
                - If a circle is detected abort
                - Once finished, pop the element from the recursiveSearch stack.
            3. If no component is found, use the default value.
            """
        )
    }
    
    func passedAllRequirements(_ dependingComponent: DependingComponent) {
        let dependingComponentsCount = dependingComponents.count
        dependingComponents.removeAll(where: { $0 === dependingComponent })
        assert(
            dependingComponentsCount - 1 == dependingComponents.count,
            """
            Only call `passedAllRequirements` in the `dependencyResolution(_: DependencyManager)` function of your `DependingComponent`.
            """
        )
        
        guard let dependingComponent = dependingComponent as? _AnyComponent else {
            assertionFailure(
                """
                A `DependingComponent` must also conform to `Component`.
                Please ensure that \(String(describing: type(of: dependingComponent))) conforms to `Component`.
                """
            )
            return
        }
        
        sortedComponents.append(dependingComponent)
        
        // Call the dependency resolution mechanism on the next element in the `dependingComponents` if we are not in a recursive serach.
        if recursiveSearch.isEmpty {
            dependingComponents.first?.dependencyResolution(self)
        }
    }
}
