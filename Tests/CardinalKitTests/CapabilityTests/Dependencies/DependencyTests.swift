//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import SwiftUI
import XCTest
import XCTRuntimeAssertions


private final class TestComponent1<ComponentStandard: Standard>: Component {
    @Dependency var testComponent2 = TestComponent2<ComponentStandard>()
    @Dependency var testComponent3: TestComponent3<ComponentStandard>
}

private final class TestComponent2<ComponentStandard: Standard>: Component {
    @Dependency var testComponent4 = TestComponent4<ComponentStandard>()
    @Dependency var testComponent5 = TestComponent5<ComponentStandard>()
    @Dependency var testComponent3: TestComponent3<ComponentStandard>
}

private final class TestComponent3<ComponentStandard: Standard>: Component, DefaultInitializable {}

private final class TestComponent4<ComponentStandard: Standard>: Component {
    @Dependency var testComponent5 = TestComponent5<ComponentStandard>()
}

private final class TestComponent5<ComponentStandard: Standard>: Component {}

private final class TestComponent6<ComponentStandard: Standard>: Component {}

private final class TestComponent7<ComponentStandard: Standard>: Component {
    @Dependency var testComponent1 = TestComponent1<ComponentStandard>()
}

private final class TestComponentCircle1<ComponentStandard: Standard>: Component {
    @Dependency var testComponentCircle2 = TestComponentCircle2<ComponentStandard>()
}

private final class TestComponentCircle2<ComponentStandard: Standard>: Component {
    @Dependency var testComponentCircle1 = TestComponentCircle1<ComponentStandard>()
}

private final class TestComponentItself<ComponentStandard: Standard>: Component {
    @Dependency var testComponentItself = TestComponentItself<ComponentStandard>()
}


final class DependencyTests: XCTestCase {
    func testComponentDependencyChain() throws {
        let components: [any Component<MockStandard>] = [
            TestComponent6<MockStandard>(),
            TestComponent1<MockStandard>(),
            TestComponent7<MockStandard>()
        ]
        let sortedComponents = DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 7)
        
        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent6<MockStandard>)
        let testComponentMock5 = try XCTUnwrap(sortedComponents[1] as? TestComponent5<MockStandard>)
        let testComponentMock4 = try XCTUnwrap(sortedComponents[2] as? TestComponent4<MockStandard>)
        let testComponentMock3 = try XCTUnwrap(sortedComponents[3] as? TestComponent3<MockStandard>)
        let testComponentMock2 = try XCTUnwrap(sortedComponents[4] as? TestComponent2<MockStandard>)
        let testComponentMock1 = try XCTUnwrap(sortedComponents[5] as? TestComponent1<MockStandard>)
        _ = try XCTUnwrap(sortedComponents[6] as? TestComponent7<MockStandard>)
        
        XCTAssert(testComponentMock4.testComponent5 === testComponentMock5)
        XCTAssert(testComponentMock2.testComponent5 === testComponentMock5)
        XCTAssert(testComponentMock2.testComponent4 === testComponentMock4)
        XCTAssert(testComponentMock2.testComponent3 === testComponentMock3)
        XCTAssert(testComponentMock1.testComponent2 === testComponentMock2)
        XCTAssert(testComponentMock1.testComponent3 === testComponentMock3)
        XCTAssert(testComponentMock1.testComponent2.testComponent3 === testComponentMock3)
        XCTAssert(testComponentMock1.testComponent2.testComponent4.testComponent5 === testComponentMock5)
    }

    func testAlreadyInDependableComponents() throws {
        let components: [any Component<MockStandard>] = [
            TestComponent2<MockStandard>(),
            TestComponent5<MockStandard>()
        ]
        let sortedComponents = DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 4)
        
        let testComponent5 = try XCTUnwrap(sortedComponents[0] as? TestComponent5<MockStandard>)
        let testComponent4 = try XCTUnwrap(sortedComponents[1] as? TestComponent4<MockStandard>)
        let testComponent3 = try XCTUnwrap(sortedComponents[2] as? TestComponent3<MockStandard>)
        let testComponent2 = try XCTUnwrap(sortedComponents[3] as? TestComponent2<MockStandard>)
        
        XCTAssert(testComponent4.testComponent5 === testComponent5)
        XCTAssert(testComponent2.testComponent5 === testComponent5)
        XCTAssert(testComponent2.testComponent4 === testComponent4)
        XCTAssert(testComponent2.testComponent3 === testComponent3)
    }

    func testComponentDependencyMultipleTimes() throws {
        let components: [any Component<MockStandard>] = [
            TestComponent5<MockStandard>(),
            TestComponent4<MockStandard>(),
            TestComponent4<MockStandard>()
        ]
        let sortedComponents = DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 3)

        let testComponent5 = try XCTUnwrap(sortedComponents[0] as? TestComponent5<MockStandard>)
        let testComponent40 = try XCTUnwrap(sortedComponents[1] as? TestComponent4<MockStandard>)
        let testComponent41 = try XCTUnwrap(sortedComponents[2] as? TestComponent4<MockStandard>)
        
        XCTAssert(testComponent40 !== testComponent41)
        
        XCTAssert(testComponent40.testComponent5 === testComponent5)
        XCTAssert(testComponent41.testComponent5 === testComponent5)
    }

    func testComponentDependencyChainMultipleTimes() throws {
        let components: [any Component<MockStandard>] = [
            TestComponent2<MockStandard>(),
            TestComponent2<MockStandard>()
        ]
        let sortedComponents = DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 5)

        let testComponent5 = try XCTUnwrap(sortedComponents[0] as? TestComponent5<MockStandard>)
        let testComponent4 = try XCTUnwrap(sortedComponents[1] as? TestComponent4<MockStandard>)
        let testComponent3 = try XCTUnwrap(sortedComponents[2] as? TestComponent3<MockStandard>)
        let testComponent20 = try XCTUnwrap(sortedComponents[3] as? TestComponent2<MockStandard>)
        let testComponent21 = try XCTUnwrap(sortedComponents[4] as? TestComponent2<MockStandard>)
        
        XCTAssert(testComponent4.testComponent5 === testComponent5)
        
        XCTAssert(testComponent20 !== testComponent21)
        
        XCTAssert(testComponent20.testComponent3 === testComponent3)
        XCTAssert(testComponent21.testComponent3 === testComponent3)
        XCTAssert(testComponent20.testComponent4 === testComponent4)
        XCTAssert(testComponent21.testComponent4 === testComponent4)
        XCTAssert(testComponent20.testComponent5 === testComponent5)
        XCTAssert(testComponent21.testComponent5 === testComponent5)
        
        XCTAssert(testComponent20.testComponent4.testComponent5 === testComponent5)
        XCTAssert(testComponent21.testComponent4.testComponent5 === testComponent5)
    }


    func testComponentNoDependency() throws {
        let components: [any Component<MockStandard>] = [TestComponent5<MockStandard>()]
        let sortedComponents = DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 1)

        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent5<MockStandard>)
    }

    func testComponentNoDependencyMultipleTimes() throws {
        let components: [any Component<MockStandard>] = [
            TestComponent5<MockStandard>(),
            TestComponent5<MockStandard>(),
            TestComponent5<MockStandard>()
        ]
        let sortedComponents = DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 3)

        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent5<MockStandard>)
        _ = try XCTUnwrap(sortedComponents[1] as? TestComponent5<MockStandard>)
        _ = try XCTUnwrap(sortedComponents[2] as? TestComponent5<MockStandard>)
    }

    func testComponentCycle() throws {
        let components: [any Component<MockStandard>] = [
            TestComponentCircle1<MockStandard>()
        ]

        try XCTRuntimePrecondition {
            _ = DependencyManager(components).sortedComponents
        }
    }
}
