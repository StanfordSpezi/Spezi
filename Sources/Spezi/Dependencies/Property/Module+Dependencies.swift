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
    /// You can use this property wrapper inside your `Module` to define dependencies to other ``Module``s.
    ///
    /// - Note: You can access the contents of `@Dependency` once your ``Module/configure()-5pa83`` method is called (e.g., it must not be used in the `init`).
    ///
    /// The below code sample demonstrates a simple, singular dependence on the `ExampleModuleDependency` module.
    ///
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency var exampleDependency = ExampleModuleDependency()
    /// }
    /// ```
    ///
    /// Some modules do not need a default value assigned to the property if they provide a default configuration and conform to ``DefaultInitializable``.
    /// ```swift
    /// class ExampleModule: Module {
    ///     @Dependency var exampleDependency: ExampleModuleDependency
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
    ///     @Dependency var exampleDependency: ExampleModuleDependency?
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
    /// The `@Dependency` property wrapper, allows you to define your dependencies using a result-builder-based appraoch.
    ///
    /// Below is a short code example that demonstrates this functionality.
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
    public typealias Dependency<Value> = _DependencyPropertyWrapper<Value>
}
