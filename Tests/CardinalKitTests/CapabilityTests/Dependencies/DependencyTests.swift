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
import XCTRuntimeAssertions


private struct TestStandard: Standard {}

private class TestComponent1<ComponentStandard: Standard>: Component {
    @_DependencyPropertyWrapper var testComponent2 = TestComponent2<ComponentStandard>()
    @_DependencyPropertyWrapper var testComponent3: TestComponent3<ComponentStandard>
}

private class TestComponent2<ComponentStandard: Standard>: Component {
    @_DependencyPropertyWrapper var testComponent4 = TestComponent4<ComponentStandard>()
    @_DependencyPropertyWrapper var testComponent5 = TestComponent5<ComponentStandard>()
    @_DependencyPropertyWrapper var testComponent3: TestComponent3<ComponentStandard>
}

private final class TestComponent3<ComponentStandard: Standard>: Component, DefaultInitializable {}

private class TestComponent4<ComponentStandard: Standard>: Component {
    @_DependencyPropertyWrapper var testComponent5 = TestComponent5<ComponentStandard>()
}

private class TestComponent5<ComponentStandard: Standard>: Component {}

private class TestComponent6<ComponentStandard: Standard>: Component {}

private class TestComponent7<ComponentStandard: Standard>: Component {
    @_DependencyPropertyWrapper var testComponent1 = TestComponent1<ComponentStandard>()
}

private class TestComponentCircle1<ComponentStandard: Standard>: Component {
    @_DependencyPropertyWrapper var testComponentCircle2 = TestComponentCircle2<ComponentStandard>()
}

private class TestComponentCircle2<ComponentStandard: Standard>: Component {
    @_DependencyPropertyWrapper var testComponentCircle1 = TestComponentCircle1<ComponentStandard>()
}

private class TestComponentItself<ComponentStandard: Standard>: Component {
    @_DependencyPropertyWrapper var testComponentItself = TestComponentItself<ComponentStandard>()
}


final class DependencyTests: XCTestCase {
    func testComponentDependencyChain() throws {
        let components: [_AnyComponent] = [
            TestComponent6<MockStandard>(),
            TestComponent1<MockStandard>(),
            TestComponent7<MockStandard>(),
            TestComponent1<TestStandard>(),
            TestComponent7<TestStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 13)
        
        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent6<MockStandard>)
        let testComponentMock5 = try XCTUnwrap(sortedComponents[1] as? TestComponent5<MockStandard>)
        let testComponentMock4 = try XCTUnwrap(sortedComponents[2] as? TestComponent4<MockStandard>)
        let testComponentMock3 = try XCTUnwrap(sortedComponents[3] as? TestComponent3<MockStandard>)
        let testComponentMock2 = try XCTUnwrap(sortedComponents[4] as? TestComponent2<MockStandard>)
        let testComponentMock1 = try XCTUnwrap(sortedComponents[5] as? TestComponent1<MockStandard>)
        _ = try XCTUnwrap(sortedComponents[6] as? TestComponent7<MockStandard>)
        let testComponentTest5 = try XCTUnwrap(sortedComponents[7] as? TestComponent5<TestStandard>)
        let testComponentTest4 = try XCTUnwrap(sortedComponents[8] as? TestComponent4<TestStandard>)
        let testComponentTest3 = try XCTUnwrap(sortedComponents[9] as? TestComponent3<TestStandard>)
        let testComponentTest2 = try XCTUnwrap(sortedComponents[10] as? TestComponent2<TestStandard>)
        let testComponentTest1 = try XCTUnwrap(sortedComponents[11] as? TestComponent1<TestStandard>)
        _ = try XCTUnwrap(sortedComponents[12] as? TestComponent7<TestStandard>)
        
        XCTAssert(testComponentMock4.testComponent5 === testComponentMock5)
        XCTAssert(testComponentMock2.testComponent5 === testComponentMock5)
        XCTAssert(testComponentMock2.testComponent4 === testComponentMock4)
        XCTAssert(testComponentMock2.testComponent3 === testComponentMock3)
        XCTAssert(testComponentMock1.testComponent2 === testComponentMock2)
        XCTAssert(testComponentMock1.testComponent3 === testComponentMock3)
        XCTAssert(testComponentMock1.testComponent2.testComponent3 === testComponentMock3)
        XCTAssert(testComponentMock1.testComponent2.testComponent4.testComponent5 === testComponentMock5)
        
        XCTAssert(testComponentTest4.testComponent5 === testComponentTest5)
        XCTAssert(testComponentTest2.testComponent5 === testComponentTest5)
        XCTAssert(testComponentTest2.testComponent4 === testComponentTest4)
        XCTAssert(testComponentTest2.testComponent3 === testComponentTest3)
        XCTAssert(testComponentTest1.testComponent2 === testComponentTest2)
        XCTAssert(testComponentTest1.testComponent3 === testComponentTest3)
        XCTAssert(testComponentTest1.testComponent2.testComponent3 === testComponentTest3)
        XCTAssert(testComponentTest1.testComponent2.testComponent4.testComponent5 === testComponentTest5)
    }

    func testAlreadyInDependableComponents() throws {
        let components: [_AnyComponent] = [
            TestComponent2<MockStandard>(),
            TestComponent5<MockStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents

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
        let components: [_AnyComponent] = [
            TestComponent5<MockStandard>(),
            TestComponent4<MockStandard>(),
            TestComponent4<MockStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 3)

        let testComponent5 = try XCTUnwrap(sortedComponents[0] as? TestComponent5<MockStandard>)
        let testComponent40 = try XCTUnwrap(sortedComponents[1] as? TestComponent4<MockStandard>)
        let testComponent41 = try XCTUnwrap(sortedComponents[2] as? TestComponent4<MockStandard>)
        
        XCTAssert(testComponent40 !== testComponent41)
        
        XCTAssert(testComponent40.testComponent5 === testComponent5)
        XCTAssert(testComponent41.testComponent5 === testComponent5)
    }

    func testComponentDependencyChainMultipleTimes() throws {
        let components: [_AnyComponent] = [
            TestComponent2<MockStandard>(),
            TestComponent2<MockStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents

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
        let components: [_AnyComponent] = [TestComponent5<MockStandard>(), TestComponent5<TestStandard>()]
        let sortedComponents = _DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 2)

        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent5<MockStandard>)
        _ = try XCTUnwrap(sortedComponents[1] as? TestComponent5<TestStandard>)
    }

    func testComponentNoDependencyMultipleTimes() throws {
        let components: [_AnyComponent] = [
            TestComponent5<MockStandard>(),
            TestComponent5<MockStandard>(),
            TestComponent5<MockStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents

        XCTAssertEqual(sortedComponents.count, 3)

        _ = try XCTUnwrap(sortedComponents[0] as? TestComponent5<MockStandard>)
        _ = try XCTUnwrap(sortedComponents[1] as? TestComponent5<MockStandard>)
        _ = try XCTUnwrap(sortedComponents[2] as? TestComponent5<MockStandard>)
    }

    func testComponentCycle() throws {
        let components: [_AnyComponent] = [
            TestComponentCircle1<MockStandard>()
        ]

        try XCTRuntimePrecondition {
            _ = _DependencyManager(components).sortedComponents
        }
    }
}
