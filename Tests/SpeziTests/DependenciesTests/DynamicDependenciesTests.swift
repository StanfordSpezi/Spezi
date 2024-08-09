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


private enum DynamicDependenciesTestCase: CaseIterable {
    case twoDependencies
    case duplicatedDependencies
    case noDependencies

    
    var dynamicDependencies: _DependencyPropertyWrapper<[any Module]> {
        switch self {
        case .twoDependencies:
            return .init {
                TestModule2()
                TestModule3()
            }
        case .duplicatedDependencies:
            return .init {
                TestModule2()
                TestModule3()
                TestModule3()
            }
        case .noDependencies:
            return .init()
        }
    }
    
    var expectedNumberOfModules: Int {
        switch self {
        case .twoDependencies:
            return 3
        case .duplicatedDependencies:
            return 4
        case .noDependencies:
            return 1
        }
    }
    
    
    func evaluateExpectations(modules: [any Module]) throws {
        switch self {
        case .twoDependencies:
            XCTAssertEqual(modules.count, 2)
            let testModule2 = try modules.moduleOfType(TestModule2.self)
            let testModule3 = try modules.moduleOfType(TestModule3.self)
            XCTAssert(testModule2 !== testModule3)
        case .duplicatedDependencies:
            XCTAssertEqual(modules.count, 3)
            let testModule2 = try modules.moduleOfType(TestModule2.self)
            let testModule3 = try modules.moduleOfType(TestModule3.self, expectedNumber: 2)
            XCTAssert(testModule2 !== testModule3)
        case .noDependencies:
            XCTAssertEqual(modules.count, 0)
        }
    }
}

private final class TestModule1: Module {
    @Dependency var dynamicDependencies: [any Module]
    let testCase: DynamicDependenciesTestCase
    
    
    init(_ testCase: DynamicDependenciesTestCase) {
        self._dynamicDependencies = testCase.dynamicDependencies
        self.testCase = testCase
    }
    
    
    func evaluateExpectations() throws {
        try testCase.evaluateExpectations(modules: dynamicDependencies)
    }
}

private final class TestModule2: Module {}

private final class TestModule3: Module {}


final class DynamicDependenciesTests: XCTestCase {
    @MainActor
    func testDynamicDependencies() throws {
        for dynamicDependenciesTestCase in DynamicDependenciesTestCase.allCases {
            let modules: [any Module] = [
                TestModule1(dynamicDependenciesTestCase)
            ]

            let initializedModules = DependencyManager.resolve(modules)
            XCTAssertEqual(initializedModules.count, dynamicDependenciesTestCase.expectedNumberOfModules)
            
            try initializedModules.moduleOfType(TestModule1.self).evaluateExpectations()
        }
    }
}
