//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// The ``DependencyDescriptor`` protocol is the base for any property wrapper used to describe ``Component`` dependencies.
/// It is generally not needed to implement types conforming to ``DependencyDescriptor`` when using Spezi.
///
/// Refer to the ``Component/Dependency`` and ``Component/DynamicDependencies`` property wrappers for more information.
public protocol DependencyDescriptor {
    /// Used by the ``DependencyManager`` to gather dependency information.
    func gatherDependency(dependencyManager: DependencyManager)
    /// Used by the ``DependencyManager`` to inject resolved dependency information into a ``DependencyDescriptor``.
    func inject(dependencyManager: DependencyManager)
}


extension Component {
    var dependencyDescriptors: [any DependencyDescriptor] {
        let mirror = Mirror(reflecting: self)
        var dependencies: [any DependencyDescriptor] = []
        
        for child in mirror.children {
            guard let dependencyPropertyWrapper = child.value as? any DependencyDescriptor else {
                continue
            }
            dependencies.append(dependencyPropertyWrapper)
        }
        
        return dependencies
    }
}
