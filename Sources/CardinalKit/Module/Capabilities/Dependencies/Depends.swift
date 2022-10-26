//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// Defines a dependency of a ``DependingComponent`` instance.
///
/// A ``DependingComponent`` can define the dependencies using the ``Depends`` type:
/// ```
/// private class ExampleComponent<ComponentStandard: Standard>: DependingComponent {
///    var dependencies: [any Dependency] {
///         Depends(on: ExampleComponentDependency<ComponentStandard>.self, defaultValue: ExampleComponentDependency())
///     }
/// }
/// ```
public struct Depends<T: Component>: Dependency {
    public typealias ComponentStandard = T.ComponentStandard
    
    
    let defaultValue: () -> (T)
    
    
    /// Defines a dependency of a ``DependingComponent`` instance.
    ///
    /// A ``DependingComponent`` can define the dependencies using the ``Depends`` type:
    /// ```
    /// private class ExampleComponent<ComponentStandard: Standard>: DependingComponent {
    ///    var dependencies: [any Dependency] {
    ///         Depends(on: ExampleComponentDependency<ComponentStandard>.self, defaultValue: ExampleComponentDependency())
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - dependencyType: The type of the ``Component`` that the ``DependingComponent`` depends on.
    ///   - defaultValue: A default value if the ``Component`` is not found in the ``CardinalKitAppDelegate/configuration`` definition.
    public init(on dependencyType: T.Type = T.self, defaultValue: @autoclosure @escaping () -> T) {
        self.defaultValue = defaultValue
    }
    
    // We want the visit function to be hidden from autocompletion and document generation. Therefore, we use the `_` prefix.
    public func _visit(dependencyManager: _DependencyManager) { // swiftlint:disable:this identifier_name
        dependencyManager.require(T.self, defaultValue: defaultValue())
    }
}
