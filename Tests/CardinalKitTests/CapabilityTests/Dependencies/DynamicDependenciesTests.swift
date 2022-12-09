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


private enum DynamicDependenciesTestCase: CaseIterable {
    case twoDependencies
    case duplicatedDependencies
    case noDependencies
    case dependencyCircle
    
    
    var dynamicDependencies: _DynamicDependenciesPropertyWrapper<MockStandard> {
        switch self {
        case .twoDependencies:
            return _DynamicDependenciesPropertyWrapper(
                componentProperties: [
                    _DependencyPropertyWrapper(wrappedValue: TestComponent2()),
                    _DependencyPropertyWrapper(wrappedValue: TestComponent3())
                ]
            )
        case .duplicatedDependencies:
            return _DynamicDependenciesPropertyWrapper(
                componentProperties: [
                    _DependencyPropertyWrapper(wrappedValue: TestComponent2()),
                    _DependencyPropertyWrapper(wrappedValue: TestComponent3()),
                    _DependencyPropertyWrapper(wrappedValue: TestComponent3())
                ]
            )
        case .noDependencies:
            return _DynamicDependenciesPropertyWrapper(componentProperties: [])
        case .dependencyCircle:
            return _DynamicDependenciesPropertyWrapper(
                componentProperties: [
                    _DependencyPropertyWrapper(wrappedValue: TestComponentCircle1()),
                    _DependencyPropertyWrapper(wrappedValue: TestComponentCircle2())
                ]
            )
        }
    }
    
    var expectedNumberOfComponents: Int {
        switch self {
        case .twoDependencies, .duplicatedDependencies:
            return 3
        case .noDependencies:
            return 1
        case .dependencyCircle:
            XCTFail("Should never be called!")
            return -1
        }
    }
    
    
    func evaluateExpectations(components: [any Component<MockStandard>]) throws {
        switch self {
        case .twoDependencies:
            XCTAssertEqual(components.count, 2)
            let testComponent2 = try components.componentOfType(TestComponent2<MockStandard>.self)
            let testComponent3 = try components.componentOfType(TestComponent3<MockStandard>.self)
            XCTAssert(testComponent2 !== testComponent3)
        case .duplicatedDependencies:
            XCTAssertEqual(components.count, 3)
            let testComponent2 = try components.componentOfType(TestComponent2<MockStandard>.self)
            let testComponent3 = try components.componentOfType(TestComponent3<MockStandard>.self, expectedNumber: 2)
            XCTAssert(testComponent2 !== testComponent3)
        case .noDependencies:
            XCTAssertEqual(components.count, 0)
        case .dependencyCircle:
            XCTFail("Should never be called!")
        }
    }
}

private final class TestComponent1: Component {
    typealias ComponentStandard = MockStandard
    
    @DynamicDependencies var dynamicDependencies: [any Component<ComponentStandard>]
    let testCase: DynamicDependenciesTestCase
    
    
    init(_ testCase: DynamicDependenciesTestCase) {
        self._dynamicDependencies = testCase.dynamicDependencies
        self.testCase = testCase
    }
    
    
    func evaluateExpectations() throws {
        try testCase.evaluateExpectations(components: dynamicDependencies)
    }
}

private final class TestComponent2<ComponentStandard: Standard>: Component {}

private final class TestComponent3<ComponentStandard: Standard>: Component {}

private final class TestComponentCircle1<ComponentStandard: Standard>: Component {
    @Dependency var testComponentCircle2 = TestComponentCircle2<ComponentStandard>()
}

private final class TestComponentCircle2<ComponentStandard: Standard>: Component {
    @Dependency var testComponentCircle1 = TestComponentCircle1<ComponentStandard>()
}


final class DynamicDependenciesTests: XCTestCase {
    func testDynamicDependencies() throws {
        for dynamicDependenciesTestCase in DynamicDependenciesTestCase.allCases {
            let components: [any Component<MockStandard>] = [
                TestComponent1(dynamicDependenciesTestCase)
            ]
            
            guard dynamicDependenciesTestCase != .dependencyCircle else {
                try XCTRuntimePrecondition {
                    _ = DependencyManager(components).sortedComponents
                }
                return
            }
            
            let sortedComponents = DependencyManager(components).sortedComponents
            XCTAssertEqual(sortedComponents.count, dynamicDependenciesTestCase.expectedNumberOfComponents)
            
            try sortedComponents.componentOfType(TestComponent1.self).evaluateExpectations()
        }
    }
}
