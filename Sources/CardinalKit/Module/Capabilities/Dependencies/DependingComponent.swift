//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// A ``DependingComponent`` can define the dependencies to other ``Component``s using the ``DependingComponent/dependencies-67sug`` computed property.
///
/// A ``DependingComponent`` can define the dependencies using the ``Depends`` type:
/// ```
/// private class ExampleComponent<ComponentStandard: Standard>: DependingComponent {
///    var dependencies: [any Dependency] {
///         Depends(on: ExampleComponentDependency<ComponentStandard>.self, defaultValue: ExampleComponentDependency())
///     }
/// }
/// ```
public protocol DependingComponent: Component, AnyObject {
    @DependencyBuilder<ComponentStandard>
    var dependencies: [any Dependency] { get }
}


extension DependingComponent {
    // A documentation for this methodd exists in the `DependingComponent` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public var dependencies: [any Dependency] { [] }
}
