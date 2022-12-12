//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Refer to ``Component/DynamicDependencies`` for information on how to use the `@DynamicDependencies` property wrapper.
/// Do not use the `_DynamicDependenciesPropertyWrapper` directly.
@propertyWrapper
public class _DynamicDependenciesPropertyWrapper<S: Standard>: DependencyDescriptor {
    // swiftlint:disable:previous type_name
    // We want the _DependencyPropertyWrapper type to be hidden from autocompletion and document generation.
    
    private var componentProperties: [any ComponentDependency<S>]
    
    
    public var wrappedValue: [any Component<S>] {
        componentProperties.compactMap {
            let component = $0.wrappedValue as any Component
            return component as? any Component<S>
        }
    }
    
    
    /// Refer to ``Component/DynamicDependencies`` for information on how to use the `@DynamicDependencies` property wrapper.
    /// Do not use the `_DynamicDependenciesPropertyWrapper` directly.
    public init(componentProperties: @escaping @autoclosure () -> ([any ComponentDependency<S>])) {
        self.componentProperties = componentProperties()
    }
    
    
    public func gatherDependency(dependencyManager: DependencyManager<S>) {
        for componentProperty in componentProperties {
            garther(componentProperty, in: dependencyManager)
        }
    }
    
    private func garther<D: ComponentDependency>(_ componentProperty: D, in dependencyManager: DependencyManager<S>) where D.PropertyStandard == S {
        dependencyManager.require(D.ComponentType.self, defaultValue: componentProperty.defaultValue())
    }
    
    public func inject(dependencyManager: DependencyManager<S>) {
        for componentProperty in componentProperties {
            inject(dependencyManager: dependencyManager, into: componentProperty)
        }
    }
    
    private func inject<D: ComponentDependency>(
        dependencyManager: DependencyManager<S>,
        into componentProperty: D
    ) where D.PropertyStandard == S {
        dependencyManager.inject(D.ComponentType.self, into: componentProperty)
    }
}
