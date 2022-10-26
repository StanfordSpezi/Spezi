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

private class TestComponent1<ComponentStandard: Standard>: DependingComponent {
    var dependencies: [any Dependency] {
        Depends(on: TestComponent2<ComponentStandard>.self, defaultValue: TestComponent2<ComponentStandard>())
        Depends(on: TestComponent3<ComponentStandard>.self, defaultValue: TestComponent3())
    }
}

private class TestComponent2<ComponentStandard: Standard>: DependingComponent {
    var dependencies: [any Dependency] {
        Depends(on: TestComponent4<ComponentStandard>.self, defaultValue: TestComponent4())
        Depends(on: TestComponent5<ComponentStandard>.self, defaultValue: TestComponent5())
        Depends(on: TestComponent3<ComponentStandard>.self, defaultValue: TestComponent3())
    }
}

private class TestComponent3<ComponentStandard: Standard>: Component {}

private class TestComponent4<ComponentStandard: Standard>: DependingComponent {
    var dependencies: [any Dependency] {
        Depends(on: TestComponent5<ComponentStandard>.self, defaultValue: TestComponent5())
    }
}

private class TestComponent5<ComponentStandard: Standard>: DependingComponent {}

private class TestComponent6<ComponentStandard: Standard>: Component {}

private class TestComponent7<ComponentStandard: Standard>: DependingComponent {
    var dependencies: [any Dependency] {
        Depends(on: TestComponent1<ComponentStandard>.self, defaultValue: TestComponent1<ComponentStandard>())
    }
}


private class TestComponentCircle1<ComponentStandard: Standard>: Component, DependingComponent {
    var dependencies: [any Dependency] {
        Depends(on: TestComponentCircle2<ComponentStandard>.self, defaultValue: TestComponentCircle2())
    }
}

private class TestComponentCircle2<ComponentStandard: Standard>: Component, DependingComponent {
    var dependencies: [any Dependency] {
        Depends(on: TestComponentCircle1<ComponentStandard>.self, defaultValue: TestComponentCircle1())
    }
}

private class TestComponentItself<ComponentStandard: Standard>: Component, DependingComponent {
    var dependencies: [any Dependency] {
        Depends(on: TestComponentItself<ComponentStandard>.self, defaultValue: TestComponentItself())
    }
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
        
        XCTAssertTrue(type(of: sortedComponents[0]) == TestComponent6<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[1]) == TestComponent5<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[2]) == TestComponent4<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[3]) == TestComponent3<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[4]) == TestComponent2<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[5]) == TestComponent1<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[6]) == TestComponent7<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[7]) == TestComponent5<TestStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[8]) == TestComponent4<TestStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[9]) == TestComponent3<TestStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[10]) == TestComponent2<TestStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[11]) == TestComponent1<TestStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[12]) == TestComponent7<TestStandard>.self)
    }
    
    func testAlreadyInDependableComponents() throws {
        let components: [_AnyComponent] = [
            TestComponent2<MockStandard>(),
            TestComponent5<MockStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents
        
        XCTAssertEqual(sortedComponents.count, 4)
        
        XCTAssertTrue(type(of: sortedComponents[0]) == TestComponent5<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[1]) == TestComponent4<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[2]) == TestComponent3<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[3]) == TestComponent2<MockStandard>.self)
    }
    
    func testComponentDependencyMultipleTimes() throws {
        let components: [_AnyComponent] = [
            TestComponent5<MockStandard>(),
            TestComponent4<MockStandard>(),
            TestComponent4<MockStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents
        
        XCTAssertEqual(sortedComponents.count, 3)
        
        XCTAssertTrue(type(of: sortedComponents[0]) == TestComponent5<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[1]) == TestComponent4<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[2]) == TestComponent4<MockStandard>.self)
    }
    
    func testComponentDependencyChainMultipleTimes() throws {
        let components: [_AnyComponent] = [
            TestComponent2<MockStandard>(),
            TestComponent2<MockStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents
        
        XCTAssertEqual(sortedComponents.count, 5)
        
        XCTAssertTrue(type(of: sortedComponents[0]) == TestComponent5<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[1]) == TestComponent4<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[2]) == TestComponent3<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[3]) == TestComponent2<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[4]) == TestComponent2<MockStandard>.self)
    }
    
    
    func testComponentNoDependency() throws {
        let components: [_AnyComponent] = [TestComponent5<MockStandard>(), TestComponent5<TestStandard>()]
        let sortedComponents = _DependencyManager(components).sortedComponents
        
        XCTAssertEqual(sortedComponents.count, 2)
        
        XCTAssertTrue(type(of: sortedComponents[0]) == TestComponent5<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[1]) == TestComponent5<TestStandard>.self)
    }
    
    func testComponentNoDependencyMultipleTimes() throws {
        let components: [_AnyComponent] = [
            TestComponent5<MockStandard>(),
            TestComponent5<MockStandard>(),
            TestComponent5<MockStandard>()
        ]
        let sortedComponents = _DependencyManager(components).sortedComponents
        
        XCTAssertEqual(sortedComponents.count, 3)
        
        XCTAssertTrue(type(of: sortedComponents[0]) == TestComponent5<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[1]) == TestComponent5<MockStandard>.self)
        XCTAssertTrue(type(of: sortedComponents[2]) == TestComponent5<MockStandard>.self)
    }
    
    func testComponentCycle() throws {
        let expectation = XCTestExpectation(description: "Precondition is called")
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true
        
        CardinalKitAssert.injected = CardinalKitAssert(
            precondition: { condition, message, _, _  in
                print("Precondition: \(condition()): \"\(message())\"")
                expectation.fulfill()
            }
        )
        
        let components: [_AnyComponent] = [
            TestComponentCircle1<MockStandard>()
        ]
        
        _ = _DependencyManager(components).sortedComponents
        
        wait(for: [expectation])
        
        CardinalKitAssert.reset()
    }
}
