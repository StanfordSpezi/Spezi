//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import SwiftUI
import XCTest
import XCTRuntimeAssertions


private final class TestComponent1: Component {
    @Dependency var testComponent2 = TestComponent2()
    @Dependency var testComponent3: TestComponent3
}

private final class TestComponent2: Component {
    @Dependency var testComponent4 = TestComponent4()
    @Dependency var testComponent5 = TestComponent5()
    @Dependency var testComponent3: TestComponent3
}

private final class TestComponent3: Component, DefaultInitializable {}

private final class TestComponent4: Component {
    @Dependency var testComponent5 = TestComponent5()
}

private final class TestComponent5: Component {}

private final class TestComponent6: Component {}

private final class TestComponent7: Component {
    @Dependency var testComponent1 = TestComponent1()
}

private final class TestComponentCircle1: Component {
    @Dependency var testComponentCircle2 = TestComponentCircle2()
}

private final class TestComponentCircle2: Component {
    @Dependency var testComponentCircle1 = TestComponentCircle1()
}

private final class TestComponentItself: Component {
    @Dependency var testComponentItself = TestComponentItself()
}


final class DependencyTests: XCTestCase {
    func testComponentDependencyChain() throws {
        let components: [any Component] = [
            TestComponent6(),
            TestComponent1(),
            TestComponent7()
        ]
        let sortedComponents = DependencyManager.resolve(components)

        XCTAssertEqual(sortedComponents.count, 7)
        
        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent6)
        let testComponentMock5 = try XCTUnwrap(sortedComponents[1] as? TestComponent5)
        let testComponentMock4 = try XCTUnwrap(sortedComponents[2] as? TestComponent4)
        let testComponentMock3 = try XCTUnwrap(sortedComponents[3] as? TestComponent3)
        let testComponentMock2 = try XCTUnwrap(sortedComponents[4] as? TestComponent2)
        let testComponentMock1 = try XCTUnwrap(sortedComponents[5] as? TestComponent1)
        _ = try XCTUnwrap(sortedComponents[6] as? TestComponent7)
        
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
        let components: [any Component] = [
            TestComponent2(),
            TestComponent5()
        ]
        let sortedComponents = DependencyManager.resolve(components)

        XCTAssertEqual(sortedComponents.count, 4)
        
        let testComponent5 = try XCTUnwrap(sortedComponents[0] as? TestComponent5)
        let testComponent4 = try XCTUnwrap(sortedComponents[1] as? TestComponent4)
        let testComponent3 = try XCTUnwrap(sortedComponents[2] as? TestComponent3)
        let testComponent2 = try XCTUnwrap(sortedComponents[3] as? TestComponent2)
        
        XCTAssert(testComponent4.testComponent5 === testComponent5)
        XCTAssert(testComponent2.testComponent5 === testComponent5)
        XCTAssert(testComponent2.testComponent4 === testComponent4)
        XCTAssert(testComponent2.testComponent3 === testComponent3)
    }

    func testComponentDependencyMultipleTimes() throws {
        let components: [any Component] = [
            TestComponent5(),
            TestComponent4(),
            TestComponent4()
        ]
        let sortedComponents = DependencyManager.resolve(components)

        XCTAssertEqual(sortedComponents.count, 3)

        let testComponent5 = try XCTUnwrap(sortedComponents[0] as? TestComponent5)
        let testComponent40 = try XCTUnwrap(sortedComponents[1] as? TestComponent4)
        let testComponent41 = try XCTUnwrap(sortedComponents[2] as? TestComponent4)
        
        XCTAssert(testComponent40 !== testComponent41)
        
        XCTAssert(testComponent40.testComponent5 === testComponent5)
        XCTAssert(testComponent41.testComponent5 === testComponent5)
    }

    func testComponentDependencyChainMultipleTimes() throws {
        let components: [any Component] = [
            TestComponent2(),
            TestComponent2()
        ]
        let sortedComponents = DependencyManager.resolve(components)

        XCTAssertEqual(sortedComponents.count, 5)

        let testComponent5 = try XCTUnwrap(sortedComponents[0] as? TestComponent5)
        let testComponent4 = try XCTUnwrap(sortedComponents[1] as? TestComponent4)
        let testComponent3 = try XCTUnwrap(sortedComponents[2] as? TestComponent3)
        let testComponent20 = try XCTUnwrap(sortedComponents[3] as? TestComponent2)
        let testComponent21 = try XCTUnwrap(sortedComponents[4] as? TestComponent2)
        
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
        let components: [any Component] = [TestComponent5()]
        let sortedComponents = DependencyManager.resolve(components)

        XCTAssertEqual(sortedComponents.count, 1)

        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent5)
    }

    func testComponentNoDependencyMultipleTimes() throws {
        let components: [any Component] = [
            TestComponent5(),
            TestComponent5(),
            TestComponent5()
        ]
        let sortedComponents = DependencyManager.resolve(components)

        XCTAssertEqual(sortedComponents.count, 3)

        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent5)
        _ = try XCTUnwrap(sortedComponents[1] as? TestComponent5)
        _ = try XCTUnwrap(sortedComponents[2] as? TestComponent5)
    }

    func testComponentCycle() throws {
        let components: [any Component] = [
            TestComponentCircle1()
        ]

        try XCTRuntimePrecondition {
            _ = DependencyManager.resolve(components)
        }
    }
}
