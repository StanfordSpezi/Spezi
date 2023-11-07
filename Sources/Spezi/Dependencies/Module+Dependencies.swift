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
    /// A ``Module`` can define the dependencies using the @``Module/Dependency`` property wrapper.
    ///
    /// - Note: You can access the contents of `@Dependency` once your ``Module/configure()-5pa83`` method is called (e.g., it must not be used in the `init`)
    ///     and can continue to access the Standard actor in methods like ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp``.
    ///
    /// The below code example demonstrates a simple dependence on the `ExampleModuleDependency` module.
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
    public typealias Dependency<M: Module> = _DependencyPropertyWrapper<M>
    
    
    /// Defines dynamic dependencies to other ``Module``s.
    ///
    /// In contrast to the `@Dependency` property wrapper, the `@DynamicDependencies` enables the generation of the property wrapper in the initializer and generating an
    /// arbitrary amount of dependencies that are resolved in the Spezi initialization.
    ///
    /// - Note: You can access the contents of `@DynamicDependencies` once your ``Module/configure()-5pa83`` method is called (e.g., it must not be used in the `init`)
    ///     and can continue to access the Standard actor in methods like ``LifecycleHandler/willFinishLaunchingWithOptions(_:launchOptions:)-8jatp``.
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
    public typealias DynamicDependencies = _DynamicDependenciesPropertyWrapper
}
