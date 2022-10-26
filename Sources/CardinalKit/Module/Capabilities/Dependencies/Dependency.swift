//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``Dependency`` describes the dependencies of a ``DependingComponent``.
public protocol Dependency {
    /// A ``Dependency/ComponentStandard`` defines what ``Standard`` the dependency should support.
    associatedtype ComponentStandard: Standard
    
    
    /// A function used by the internally used `DependencyManager` in CardinalKit to gather information about dependencies of a ``DependingComponent``.
    /// - Parameter dependencyManager: An instance of a `DependencyManager` used internally in CardinalKit.
    func _visit(dependencyManager: _DependencyManager) // swiftlint:disable:this identifier_name
    // We want the visit function to be hidden from autocompletion and document generation. Therefore, we use the `_` prefix.
}
