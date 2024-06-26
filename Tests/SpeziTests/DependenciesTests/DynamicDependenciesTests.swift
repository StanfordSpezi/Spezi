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
#if compiler(<6)
    case dependencyCircle
#endif

    
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
#if compiler(<6)
        case .dependencyCircle:
            return .init {
                TestModuleCircle1()
                TestModuleCircle2()
            }
#endif
        }
    }
    
    var expectedNumberOfModules: Int {
        switch self {
        case .twoDependencies, .duplicatedDependencies:
            return 3
        case .noDependencies:
            return 1
#if compiler(<6)
        case .dependencyCircle:
            XCTFail("Should never be called!")
            return -1
#endif
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
#if compiler(<6)
        case .dependencyCircle:
            XCTFail("Should never be called!")
#endif
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

#if compiler(<6)
private final class TestModuleCircle1: Module {
    @Dependency var testModuleCircle2 = TestModuleCircle2()
}

private final class TestModuleCircle2: Module {
    @Dependency var testModuleCircle1 = TestModuleCircle1()
}
#endif


final class DynamicDependenciesTests: XCTestCase {
    func testDynamicDependencies() throws {
        for dynamicDependenciesTestCase in DynamicDependenciesTestCase.allCases {
            let modules: [any Module] = [
                TestModule1(dynamicDependenciesTestCase)
            ]
            
#if compiler(<6)
            guard dynamicDependenciesTestCase != .dependencyCircle else {
                try XCTRuntimePrecondition {
                    _ = DependencyManager.resolve(modules)
                }
                return
            }
#endif

            let initializedModules = DependencyManager.resolve(modules)
            XCTAssertEqual(initializedModules.count, dynamicDependenciesTestCase.expectedNumberOfModules)
            
            try initializedModules.moduleOfType(TestModule1.self).evaluateExpectations()
        }
    }
}
