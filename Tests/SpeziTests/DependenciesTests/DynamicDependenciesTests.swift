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
    case dependencyCircle
    
    
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
        case .dependencyCircle:
            return .init {
                TestModuleCircle1()
                TestModuleCircle2()
            }
        }
    }
    
    var expectedNumberOfModules: Int {
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
        case .dependencyCircle:
            XCTFail("Should never be called!")
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

private final class TestModuleCircle1: Module {
    @Dependency var testModuleCircle2 = TestModuleCircle2()
}

private final class TestModuleCircle2: Module {
    @Dependency var testModuleCircle1 = TestModuleCircle1()
}


final class DynamicDependenciesTests: XCTestCase {
    func testDynamicDependencies() throws {
        for dynamicDependenciesTestCase in DynamicDependenciesTestCase.allCases {
            let modules: [any Module] = [
                TestModule1(dynamicDependenciesTestCase)
            ]
            
            guard dynamicDependenciesTestCase != .dependencyCircle else {
                try XCTRuntimePrecondition {
                    _ = DependencyManager.resolve(modules)
                }
                return
            }
            
            let sortedModules = DependencyManager.resolve(modules)
            XCTAssertEqual(sortedModules.count, dynamicDependenciesTestCase.expectedNumberOfModules)
            
            try sortedModules.moduleOfType(TestModule1.self).evaluateExpectations()
        }
    }
}
