//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Refer to ``Component/DynamicDependencies`` for information on how to use the `@DynamicDependencies` property wrapper.
/// Do not use the `_DynamicDependenciesPropertyWrapper` directly.
@propertyWrapper
public class _DynamicDependenciesPropertyWrapper: DependencyDescriptor {
    // swiftlint:disable:previous type_name
    // We want the _DependencyPropertyWrapper type to be hidden from autocompletion and document generation.
    
    private var componentProperties: [any ComponentDependency]
    
    
    public var wrappedValue: [any Component] {
        componentProperties.map {
            $0.wrappedValue as any Component
        }
    }
    
    
    /// Refer to ``Component/DynamicDependencies`` for information on how to use the `@DynamicDependencies` property wrapper.
    /// Do not use the `_DynamicDependenciesPropertyWrapper` directly.
    public init(componentProperties: @escaping @autoclosure () -> [any ComponentDependency]) {
        self.componentProperties = componentProperties()
    }
    
    
    public func gatherDependency(dependencyManager: DependencyManager) {
        for componentProperty in componentProperties {
            gather(componentProperty, in: dependencyManager)
        }
    }

    private func gather<D: ComponentDependency>(_ componentProperty: D, in dependencyManager: DependencyManager) {
        dependencyManager.require(D.ComponentType.self, defaultValue: componentProperty.defaultValue())
    }
    
    public func inject(dependencyManager: DependencyManager) {
        for componentProperty in componentProperties {
            inject(dependencyManager: dependencyManager, into: componentProperty)
        }
    }
    
    private func inject<D: ComponentDependency>(
        dependencyManager: DependencyManager,
        into componentProperty: D
    ) {
        dependencyManager.inject(D.ComponentType.self, into: componentProperty)
    }
}
