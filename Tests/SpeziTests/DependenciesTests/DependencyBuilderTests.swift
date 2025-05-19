//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import Testing

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

@Suite
struct DependencyBuilderTests {
    @Test
    @MainActor
    func dependencyCollection() {
        var collection = DependencyCollection(ExampleDependentModule())
        #expect(collection.count == 1)
        #expect(!collection.isEmpty)
        collection.append(ExampleDependentModule())
        #expect(collection.count == 2)
    }

    
    @Test
    @available(*, deprecated, message: "Propagate deprecation warning.")
    @MainActor
    func deprecatedInits() {
        let collection1 = DependencyCollection(singleEntry: ExampleDependentModule())
        let collection2 = DependencyCollection(singleEntry: {
            ExampleDependentModule()
        })
        #expect(collection1.count == 1)
        #expect(collection2.count == 1)
    }


    @Test
    @MainActor
    func dependencyBuilder() throws {
        let module = ExampleDependencyModule {
            ExampleDependentModule()
        }
        let initializedModules = DependencyManager.resolveWithoutErrors([module])
        #expect(initializedModules.count == 2)
        _ = try #require(initializedModules[0] as? ExampleDependentModule)
        _ = try #require(initializedModules[1] as? ExampleDependencyModule)
    }
}
