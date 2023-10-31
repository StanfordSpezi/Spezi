//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Module {
    /// Defines a dependency to another ``Module``.
    ///
    /// A ``Module`` can define the dependencies using the @``Module/Dependency`` property wrapper:
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency var exampleModuleDependency = ExampleModuleDependency()
    /// }
    /// ```
    ///
    /// Some modules do not need a default value assigned to the property if they provide a default configuration and conform to ``DefaultInitializable``.
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency var exampleModuleDependency: ExampleModuleDependency
    /// }
    /// ```
    ///
    /// You can access the wrapped value of the ``Dependency`` after the ``Module`` is configured using ``Module/configure()-5pa83``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp`` function.
    public typealias Dependency<M: Module> = _DependencyPropertyWrapper<M>
    
    
    /// Defines dynamic dependencies to other ``Module``s.
    ///
    /// In contrast to the `@Dependency` property wrapper, the `@DynamicDependencies` enables the generation of the property wrapper in the initializer and generating an
    /// arbitrary amount of dependencies that are resolved in the Spezi initialization.
    ///
    /// A ``Module`` can define dynamic dependencies using the @``Module/DynamicDependencies`` property wrapper and can, e.g., initialize its value in the initializer.
    /// ```swift
    /// class ExampleModule: Module {
    ///     @DynamicDependencies var dynamicDependencies: [any Module]
    ///
    ///
    ///     init() {
    ///         self._dynamicDependencies = DynamicDependencies(
    ///             moduleProperty: [
    ///                 Dependency(wrappedValue: /* ... */),
    ///                 Dependency(wrappedValue: /* ... */)
    ///             ]
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// You can access the wrapped value of the ``DynamicDependencies`` after the ``Module`` is configured using ``Module/configure()-5pa83``,
    /// e.g. in the ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp`` function.
    public typealias DynamicDependencies = _DynamicDependenciesPropertyWrapper
}
