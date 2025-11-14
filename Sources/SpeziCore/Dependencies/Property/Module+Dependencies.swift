//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension Module {
    /// Define dependency to other `Module`s.
    ///
    /// You can use the `@Dependency` property wrapper inside your ``Module`` to define dependencies to other `Module`s.
    ///
    /// - Note: You can access the contents of `@Dependency` once your ``Module/configure()-5pa83`` method is called. You cannot
    ///     access it within your `init`.
    ///
    /// ### Required Dependencies
    ///
    /// The below code sample demonstrates a simple, singular dependence on the `ExampleModuleDependency` module. If the dependency
    /// is not available (because the user didn't configure it), the application will crash at runtime.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency(ExampleModuleDependency.self) var exampleDependency
    /// }
    /// ```
    ///
    /// Some `Module`s can be used without explicit configuration, for example if they provide a default configuration by conforming to the
    /// ``DefaultInitializable`` protocol. In those cases, you can provide a default value to the `@Dependency` property wrapper
    /// that is used in case the user didn't configure the `Module` separately.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency var exampleDependency = ExampleModuleDependency()
    /// }
    /// ```
    ///
    /// ### Optional Dependencies
    ///
    /// You can define dependencies to be optional by declaring the `@Dependency` property wrapper optional.
    /// The below code examples demonstrates this functionality.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency(ExampleModuleDependency.self) var exampleDependency: ExampleModuleDependency?
    ///
    ///     func configure() {
    ///         if let exampleDependency {
    ///             // Dependency was defined by the user ...
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ### Computed Dependencies
    ///
    /// In certain circumstances your list of dependencies might not be statically known. Instead you might want to generate
    /// your list of dependencies within the initializer, based on external factors.
    /// The `@Dependency` property wrapper, allows you to define your dependencies using a result-builder-based approach or by creating
    /// a ``DependencyCollection`` yourself.
    ///
    /// - Tip: If a collection of `Module`s is part of your `Module`'s configuration and you want to impose certain protocol requirements,
    ///     you can implement your own result builder using the ``DependencyCollectionBuilder`` protocol. Refer to the documentation for more information.
    ///
    /// Below is a short code example that demonstrates how to dynamically create a list of dependencies.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency var computedDependencies: [any Module]
    ///
    ///
    ///     init() {
    ///         // a result builder to declare your module dependencies
    ///         self._computedDependencies = Dependency {
    ///             ModuleA()
    ///             ModuleB()
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Note: Use `Dependency/init(using:)` to initialize the `@Dependency` property wrapper using a ``DependencyCollection``.
    public typealias Dependency<Value> = _DependencyPropertyWrapper<Value>
}
