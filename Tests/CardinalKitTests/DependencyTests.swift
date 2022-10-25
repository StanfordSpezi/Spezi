//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import SwiftUI
import XCTest

private struct TestStandard: Standard {}

class TestComponent1<ComponentStandard: Standard>: DependingComponent, StorageKey {
    var dependencies: [any Dependency] {
        Depends(on: TestComponent2<ComponentStandard>.self, defaultValue: TestComponent2<ComponentStandard>())
    }
}

class TestComponent2<ComponentStandard: Standard>: DependingComponent, StorageKey {
    var dependencies: [any Dependency] {
        Depends(on: TestComponent3<ComponentStandard>.self, defaultValue: TestComponent3())
        Depends(on: TestComponent4<ComponentStandard>.self, defaultValue: TestComponent4())
    }
}

class TestComponent3<ComponentStandard: Standard>: DependingComponent, StorageKey {
    var dependencies: [any Dependency] {
        Depends(on: TestComponent4<ComponentStandard>.self, defaultValue: TestComponent4())
    }
}

class TestComponent4<ComponentStandard: Standard>: DependingComponent, StorageKey {}

class TestComponentCircle<ComponentStandard: Standard>: Component, DependingComponent, StorageKey {
    var dependencies: [any Dependency] {
        Depends(on: TestComponent1<ComponentStandard>.self, defaultValue: TestComponent1())
    }
}

class TestComponentItself<ComponentStandard: Standard>: Component, DependingComponent, StorageKey {
    var dependencies: [any Dependency] {
        Depends(on: TestComponentItself<ComponentStandard>.self, defaultValue: TestComponentItself())
    }
}


final class DependencyTests: XCTestCase {
    func testComponentDependencies() throws {
        let components: [_AnyComponent] = [TestComponent1<MockStandard>(), TestComponent1<TestStandard>()]
        let sortedComponents = DependencyManager(components).sortedComponents
        print(sortedComponents)
    }
}
