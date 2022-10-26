//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import XCTest


private class TestComponent1<ComponentStandard: Standard>: Component {}
private class TestComponent2<ComponentStandard: Standard>: Component {}
private class TestComponent3<ComponentStandard: Standard>: Component {}
private class TestComponent4<ComponentStandard: Standard>: Component {}
private class TestComponent5<ComponentStandard: Standard>: Component {}
private class TestComponent6<ComponentStandard: Standard>: Component {}


final class DependencyBuilderTests: XCTestCase {
    private func depedencies(loopLimit: Int, condition: Bool) -> [any Dependency] {
        @DependencyBuilder<MockStandard>
        var dependencies: [any Dependency] {
            Depends(defaultValue: TestComponent1())
            for _ in 0..<loopLimit {
                Depends(defaultValue: TestComponent2())
            }
            if condition {
                Depends(defaultValue: TestComponent3())
            }
            // The `#available(iOS 16, *)` mark is used to test `#available` in a result builder.
            // The availability check is not part of any part of the CardinalKit API.
            if #available(iOS 16, *) { // swiftlint:disable:this deployment_target
                Depends(defaultValue: TestComponent4())
            }
            if condition {
                Depends(defaultValue: TestComponent5())
            } else {
                Depends(defaultValue: TestComponent6())
            }
        }
        return dependencies
    }
    
    
    func testComponentBuilderIf() throws {
        let depedencies = depedencies(loopLimit: 3, condition: true)
        
        XCTAssertEqual(depedencies.count, 7)
        
        XCTAssertTrue(type(of: depedencies[0]) == Depends<TestComponent1<MockStandard>>.self) // First
        XCTAssertTrue(type(of: depedencies[1]) == Depends<TestComponent2<MockStandard>>.self) // Loop 1
        XCTAssertTrue(type(of: depedencies[2]) == Depends<TestComponent2<MockStandard>>.self) // Loop 2
        XCTAssertTrue(type(of: depedencies[3]) == Depends<TestComponent2<MockStandard>>.self) // Loop 3
        XCTAssertTrue(type(of: depedencies[4]) == Depends<TestComponent3<MockStandard>>.self) // If true
        XCTAssertTrue(type(of: depedencies[5]) == Depends<TestComponent4<MockStandard>>.self) // If available
        XCTAssertTrue(type(of: depedencies[6]) == Depends<TestComponent5<MockStandard>>.self) // If/else true
    }
    
    func testComponentBuilderElse() throws {
        let depedencies = depedencies(loopLimit: 3, condition: false)
        
        XCTAssertEqual(depedencies.count, 6)
        
        XCTAssertTrue(type(of: depedencies[0]) == Depends<TestComponent1<MockStandard>>.self) // First
        XCTAssertTrue(type(of: depedencies[1]) == Depends<TestComponent2<MockStandard>>.self) // Loop 1
        XCTAssertTrue(type(of: depedencies[2]) == Depends<TestComponent2<MockStandard>>.self) // Loop 2
        XCTAssertTrue(type(of: depedencies[3]) == Depends<TestComponent2<MockStandard>>.self) // Loop 3
        XCTAssertTrue(type(of: depedencies[4]) == Depends<TestComponent4<MockStandard>>.self) // If available
        XCTAssertTrue(type(of: depedencies[5]) == Depends<TestComponent6<MockStandard>>.self) // If/else false
    }
}
