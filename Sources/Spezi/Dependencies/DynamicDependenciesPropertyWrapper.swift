//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Refer to ``Module/DynamicDependencies`` for information on how to use the `@DynamicDependencies` property wrapper.
/// Do not use the `_DynamicDependenciesPropertyWrapper` directly.
@propertyWrapper
public class _DynamicDependenciesPropertyWrapper: DependencyDescriptor {
    // swiftlint:disable:previous type_name
    // We want the _DependencyPropertyWrapper type to be hidden from autocompletion and document generation.
    
    private var moduleProperties: [any ModuleDependency]
    
    
    public var wrappedValue: [any Module] {
        moduleProperties.map {
            $0.wrappedValue as any Module
        }
    }
    
    
    /// Refer to ``Module/DynamicDependencies`` for information on how to use the `@DynamicDependencies` property wrapper.
    /// Do not use the `_DynamicDependenciesPropertyWrapper` directly.
    public init(moduleProperties: @escaping @autoclosure () -> [any ModuleDependency]) {
        self.moduleProperties = moduleProperties()
    }
    
    
    public func gatherDependency(dependencyManager: DependencyManager) {
        for moduleProperty in moduleProperties {
            gather(moduleProperty, in: dependencyManager)
        }
    }

    private func gather<D: ModuleDependency>(_ moduleProperty: D, in dependencyManager: DependencyManager) {
        dependencyManager.require(D.ModuleType.self, defaultValue: moduleProperty.defaultValue())
    }
    
    public func inject(dependencyManager: DependencyManager) {
        for moduleProperty in moduleProperties {
            inject(dependencyManager: dependencyManager, into: moduleProperty)
        }
    }
    
    private func inject<D: ModuleDependency>(
        dependencyManager: DependencyManager,
        into moduleProperty: D
    ) {
        dependencyManager.inject(D.ModuleType.self, into: moduleProperty)
    }
}
