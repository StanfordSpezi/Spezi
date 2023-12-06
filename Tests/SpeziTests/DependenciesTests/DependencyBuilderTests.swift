//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import XCTRuntimeAssertions

private protocol ExampleTypeConstraint: Module {}

private final class ExampleDependencyModule: ExampleTypeConstraint {}

@resultBuilder
private enum ExampleDependencyBuilder: DependencyCollectionBuilder {
    /// An auto-closure expression, providing the default dependency value, building the ``DependencyCollection``.
    static func buildExpression<L: ExampleTypeConstraint>(_ expression: @escaping @autoclosure () -> L) -> DependencyCollection {
        DependencyCollection(singleEntry: expression)
    }
}

class ExampleModule: Module {
    @Dependency var dependencies: [any Module]
    
    
    init(
        @ExampleDependencyBuilder _ dependencies: () -> DependencyCollection
    ) {
        self._dependencies = Dependency(dependencies)
    }
}

enum ExampleConfiguration {
    static let exampleModule = ExampleModule {
        ExampleDependencyModule()
    }
}


final class DependencyBuilderTests: XCTestCase {
    func testDependencyBuilder() throws {
        XCTAssertEqual(ExampleConfiguration.exampleModule.dependencies.count, 1)
        _ = try XCTUnwrap(ExampleConfiguration.exampleModule.dependencies[0] as? ExampleDependencyModule)
    }
}
