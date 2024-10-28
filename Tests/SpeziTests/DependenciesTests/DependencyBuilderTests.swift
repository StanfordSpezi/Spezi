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
    static func buildExpression<L: ExampleTypeConstraint>(_ expression: L) -> DependencyCollection {
        DependencyCollection(expression)
    }
}

class ExampleDependencyModule: Module {
    @Dependency var dependencies: [any Module]
    
    
    init(@ExampleDependencyBuilder _ dependencies: () -> DependencyCollection) {
        self._dependencies = Dependency(using: dependencies())
    }
}


final class DependencyBuilderTests: XCTestCase {
    @MainActor
    func testDependencyCollection() {
        var collection = DependencyCollection(ExampleDependentModule())
        XCTAssertEqual(collection.count, 1)
        XCTAssertFalse(collection.isEmpty)

        collection.append(ExampleDependentModule())

        XCTAssertEqual(collection.count, 2)
    }

    @available(*, deprecated, message: "Propagate deprecation warning.")
    @MainActor
    func testDeprecatedInits() {
        let collection1 = DependencyCollection(singleEntry: ExampleDependentModule())
        let collection2 = DependencyCollection(singleEntry: {
            ExampleDependentModule()
        })

        XCTAssertEqual(collection1.count, 1)
        XCTAssertEqual(collection2.count, 1)
    }


    @MainActor
    func testDependencyBuilder() throws {
        let module = ExampleDependencyModule {
            ExampleDependentModule()
        }
        let initializedModules = DependencyManager.resolveWithoutErrors([module])
        XCTAssertEqual(initializedModules.count, 2)
        _ = try XCTUnwrap(initializedModules[0] as? ExampleDependentModule)
        _ = try XCTUnwrap(initializedModules[1] as? ExampleDependencyModule)
    }
}
