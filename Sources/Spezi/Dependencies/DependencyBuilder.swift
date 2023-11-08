//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A result builder to build a ``DependencyCollection``.
@resultBuilder
public enum DependencyBuilder {
    /// An auto-closure expression, providing the default dependency value, building the ``DependencyCollection``.
    public static func buildExpression<M: Module>(_ expression: @escaping @autoclosure () -> M) -> DependencyCollection {
        DependencyCollection(DependencyContext(defaultValue: expression))
    }

    /// Build a block of ``DependencyCollection``s.
    public static func buildBlock(_ components: DependencyCollection...) -> DependencyCollection {
        buildArray(components)
    }

    /// Build the first block of an conditional ``DependencyCollection`` component.
    public static func buildEither(first component: DependencyCollection) -> DependencyCollection {
        component
    }

    /// Build the second block of an conditional ``DependencyCollection`` component.
    public static func buildEither(second component: DependencyCollection) -> DependencyCollection {
        component
    }

    /// Build an optional ``DependencyCollection`` component.
    public static func buildOptional(_ component: DependencyCollection?) -> DependencyCollection {
        component ?? DependencyCollection()
    }

    /// Build an ``DependencyCollection`` component with limited availability.
    public static func buildLimitedAvailability(_ component: DependencyCollection) -> DependencyCollection {
        component
    }

    /// Build an array of ``DependencyCollection`` components.
    public static func buildArray(_ components: [DependencyCollection]) -> DependencyCollection {
        DependencyCollection(components.reduce(into: []) { result, component in
            result.append(contentsOf: component.entries)
        })
    }
}
