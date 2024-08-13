//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Implement a custom result builder to build a `DependencyCollection`.
///
/// A ``DependencyCollection`` is a collection of dependencies that can be passed to the ``Module/Dependency`` property wrapper of a ``Module``.
/// This protocol allows you to easily implement a result builder with custom expression, building a `DependencyCollection` component.
///
/// To create your own result builder, just add adopt the `DependencyCollectionBuilder` protocol and add your custom expressions.
/// The code example below shows the implementation of a `SpecialModuleBuilder` that only allows to build modules of type `SpecialModule`.
///
/// ```swift
/// @resultBuilder
/// enum SpecialModuleBuilder: DependencyCollectionBuilder {
///     static func buildExpression<M: SpecialModule & Module>(_ expression: M) -> DependencyCollection {
///         DependencyCollection(expression)
///     }
/// }
/// ```
///
/// You could then use this result builder to accept only `SpecialModule` conforming modules in, e.g., the initializer of your Spezi module.
/// ```swift
/// final class MyModule: Module {
///     @Dependency private var specials: [any Module]
///
///     init(@SpecialModuleBuilder modules: () -> DependencyCollection) {
///         _specials = Dependency(using: modules())
///     }
/// }
/// ```
public protocol DependencyCollectionBuilder {}


/// Default protocol implementations of a result builder constructing a ``DependencyCollection``.
extension DependencyCollectionBuilder {
    /// Build a block of `DependencyCollection`s.
    public static func buildBlock(_ components: DependencyCollection...) -> DependencyCollection {
        buildArray(components)
    }

    /// Build the first block of an conditional `DependencyCollection` component.
    public static func buildEither(first component: DependencyCollection) -> DependencyCollection {
        component
    }

    /// Build the second block of an conditional `DependencyCollection` component.
    public static func buildEither(second component: DependencyCollection) -> DependencyCollection {
        component
    }

    /// Build an optional `DependencyCollection` component.
    public static func buildOptional(_ component: DependencyCollection?) -> DependencyCollection {
        component ?? DependencyCollection()
    }

    /// Build an `DependencyCollection` component with limited availability.
    public static func buildLimitedAvailability(_ component: DependencyCollection) -> DependencyCollection {
        component
    }

    /// Build an array of `DependencyCollection` components.
    public static func buildArray(_ components: [DependencyCollection]) -> DependencyCollection {
        components.reduce(into: DependencyCollection()) { partialResult, collection in
            partialResult.append(contentsOf: collection)
        }
    }
}
