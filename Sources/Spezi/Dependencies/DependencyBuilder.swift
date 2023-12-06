//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A result builder to build a ``DependencyCollection``.
@resultBuilder
public enum DependencyBuilder: DependencyCollectionBuilder {
    /// An auto-closure expression, providing the default dependency value, building the ``DependencyCollection``.
    public static func buildExpression<M: Module>(_ expression: @escaping @autoclosure () -> M) -> DependencyCollection {
        DependencyCollection(DependencyContext(defaultValue: expression))
    }
}
