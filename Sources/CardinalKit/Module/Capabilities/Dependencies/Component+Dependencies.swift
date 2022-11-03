//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

extension Component {
    var dependencies: [any DependencyInjectable<ComponentStandard>] {
        let mirror = Mirror(reflecting: self)
        var dependencies: [any DependencyInjectable<ComponentStandard>] = []
        
        for child in mirror.children {
            guard let dependencyPropertyWrapper = child.value as? any DependencyInjectable<ComponentStandard> else {
                continue
            }
            dependencies.append(dependencyPropertyWrapper)
        }
        
        return dependencies
    }
}


extension Component {
    /// Defines a dependency to an other ``Component``.
    ///
    /// A ``Component`` can define the dependencies using the ``@Dependency`` property wrapper:
    /// ```
    /// class ExampleComponent<ComponentStandard: Standard>: Component {
    ///     @Dependency var exampleComponentDependency = ExampleComponentDependency()
    /// }
    /// ```
    ///
    /// Some component do not need a default value assigned to the property if they provide a default configuration and conform to ``DefaultInitializable``.
    /// ```
    /// class ExampleComponent<ComponentStandard: Standard>: Component {
    ///     @Dependency var exampleComponentDependency: ExampleComponentDependency
    /// }
    /// ```
    ///
    /// You can access the wrapped value of the ``Dependency`` after the ``Component`` is configured using ``Component/configure(cardinalKit:)-38pyu``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-lsab`` function.
    public typealias Dependency<C: Component> = _DependencyPropertyWrapper<C, ComponentStandard> where C.ComponentStandard == ComponentStandard
}
