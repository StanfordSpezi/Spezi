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

private final class ExampleDependentModule: ExampleTypeConstraint {}

@resultBuilder
private enum ExampleDependencyBuilder: DependencyCollectionBuilder {
    /// An auto-closure expression, providing the default dependency value, building the ``DependencyCollection``.
    static func buildExpression<L: ExampleTypeConstraint>(_ expression: @escaping @autoclosure () -> L) -> DependencyCollection {
        DependencyCollection(singleEntry: expression)
    }
}

class ExampleDependencyModule: Module {
    @Dependency var dependencies: [any Module]
    
    
    init(
        @ExampleDependencyBuilder _ dependencies: () -> DependencyCollection
    ) {
        self._dependencies = Dependency(using: dependencies())
    }
}


final class DependencyBuilderTests: XCTestCase {
    func testDependencyBuilder() throws {
        let module = ExampleDependencyModule {
            ExampleDependentModule()
        }
        let sortedModules = DependencyManager.resolve([module])
        XCTAssertEqual(sortedModules.count, 2)
        _ = try XCTUnwrap(sortedModules[0] as? ExampleDependentModule)
        _ = try XCTUnwrap(sortedModules[1] as? ExampleDependencyModule)
    }
}
