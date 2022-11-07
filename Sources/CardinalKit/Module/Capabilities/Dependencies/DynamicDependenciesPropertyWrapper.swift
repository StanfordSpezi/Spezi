//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

extension ComponentProperty {
    var anyComponent: any Component<PropertyStandard> {
        dependency!
    }
}

@propertyWrapper
public class _DynamicDependenciesPropertyWrapper<S: Standard>: DependencyDescriptor {
    // swiftlint:disable:previous type_name
    // We want the _DependencyPropertyWrapper type to be hidden from autocompletion and document generation.
    
    public var wrappedValue: [any Component<S>] {
        componentProperties.compactMap({ $0.anyComponent })
    }
    
    private var componentProperties: [any ComponentProperty<S>]
    
    
    /// Refer to ``Component/DynamicDependencies`` for information on how to use the `@DynamicDependencies` property wrapper.
    /// Do not use the `_DynamicDependenciesPropertyWrapper` directly.
    public init(componentProperties: @escaping @autoclosure () -> ([any ComponentProperty<S>])) {
        self.componentProperties = componentProperties()
    }
    
    
    public func gatherDependency(dependencyManager: DependencyManager<S>) {
        for componentProperty in componentProperties {
            garther(componentProperty, in: dependencyManager)
        }
    }
    
    private func garther<D: ComponentProperty>(_ componentProperty: D, in dependencyManager: DependencyManager<S>) where D.PropertyStandard == S {
        dependencyManager.require(D.ComponentType.self, defaultValue: componentProperty.defaultValue())
    }
    
    public func inject(dependencyManager: DependencyManager<S>) {
        for componentProperty in componentProperties {
            inject(dependencyManager: dependencyManager, into: componentProperty)
        }
    }
    
    private func inject<D: ComponentProperty>(
        dependencyManager: DependencyManager<S>,
        into componentProperty: D
    ) where D.PropertyStandard == S {
        dependencyManager.inject(D.ComponentType.self, into: componentProperty)
    }
}
