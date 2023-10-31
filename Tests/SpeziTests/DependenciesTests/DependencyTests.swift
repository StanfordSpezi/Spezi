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


private final class TestModule1: Module {
    @Dependency var testModule2 = TestModule2()
    @Dependency var testModule3: TestModule3
}

private final class TestModule2: Module {
    @Dependency var testModule4 = TestModule4()
    @Dependency var testModule5 = TestModule5()
    @Dependency var testModule3: TestModule3
}

private final class TestModule3: Module, DefaultInitializable {}

private final class TestModule4: Module {
    @Dependency var testModule5 = TestModule5()
}

private final class TestModule5: Module {}

private final class TestModule6: Module {}

private final class TestModule7: Module {
    @Dependency var testModule1 = TestModule1()
}

private final class TestModuleCircle1: Module {
    @Dependency var testModuleCircle2 = TestModuleCircle2()
}

private final class TestModuleCircle2: Module {
    @Dependency var testModuleCircle1 = TestModuleCircle1()
}

private final class TestModuleItself: Module {
    @Dependency var testModuleItself = TestModuleItself()
}


final class DependencyTests: XCTestCase {
    func testModuleDependencyChain() throws {
        let modules: [any Module] = [
            TestModule6(),
            TestModule1(),
            TestModule7()
        ]
        let sortedModules = DependencyManager.resolve(modules)

        XCTAssertEqual(sortedModules.count, 7)
        
        _ = try XCTUnwrap(sortedModules[0] as? TestModule6)
        let testModuleMock5 = try XCTUnwrap(sortedModules[1] as? TestModule5)
        let testModuleMock4 = try XCTUnwrap(sortedModules[2] as? TestModule4)
        let testModuleMock3 = try XCTUnwrap(sortedModules[3] as? TestModule3)
        let testModuleMock2 = try XCTUnwrap(sortedModules[4] as? TestModule2)
        let testModuleMock1 = try XCTUnwrap(sortedModules[5] as? TestModule1)
        _ = try XCTUnwrap(sortedModules[6] as? TestModule7)
        
        XCTAssert(testModuleMock4.testModule5 === testModuleMock5)
        XCTAssert(testModuleMock2.testModule5 === testModuleMock5)
        XCTAssert(testModuleMock2.testModule4 === testModuleMock4)
        XCTAssert(testModuleMock2.testModule3 === testModuleMock3)
        XCTAssert(testModuleMock1.testModule2 === testModuleMock2)
        XCTAssert(testModuleMock1.testModule3 === testModuleMock3)
        XCTAssert(testModuleMock1.testModule2.testModule3 === testModuleMock3)
        XCTAssert(testModuleMock1.testModule2.testModule4.testModule5 === testModuleMock5)
    }

    func testAlreadyInDependableModules() throws {
        let modules: [any Module] = [
            TestModule2(),
            TestModule5()
        ]
        let sortedModules = DependencyManager.resolve(modules)

        XCTAssertEqual(sortedModules.count, 4)
        
        let testModule5 = try XCTUnwrap(sortedModules[0] as? TestModule5)
        let testModule4 = try XCTUnwrap(sortedModules[1] as? TestModule4)
        let testModule3 = try XCTUnwrap(sortedModules[2] as? TestModule3)
        let testModule2 = try XCTUnwrap(sortedModules[3] as? TestModule2)
        
        XCTAssert(testModule4.testModule5 === testModule5)
        XCTAssert(testModule2.testModule5 === testModule5)
        XCTAssert(testModule2.testModule4 === testModule4)
        XCTAssert(testModule2.testModule3 === testModule3)
    }

    func testModuleDependencyMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule5(),
            TestModule4(),
            TestModule4()
        ]
        let sortedModules = DependencyManager.resolve(modules)

        XCTAssertEqual(sortedModules.count, 3)

        let testModule5 = try XCTUnwrap(sortedModules[0] as? TestModule5)
        let testModule40 = try XCTUnwrap(sortedModules[1] as? TestModule4)
        let testModule41 = try XCTUnwrap(sortedModules[2] as? TestModule4)
        
        XCTAssert(testModule40 !== testModule41)
        
        XCTAssert(testModule40.testModule5 === testModule5)
        XCTAssert(testModule41.testModule5 === testModule5)
    }

    func testModuleDependencyChainMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule2(),
            TestModule2()
        ]
        let sortedModules = DependencyManager.resolve(modules)

        XCTAssertEqual(sortedModules.count, 5)

        let testModule5 = try XCTUnwrap(sortedModules[0] as? TestModule5)
        let testModule4 = try XCTUnwrap(sortedModules[1] as? TestModule4)
        let testModule3 = try XCTUnwrap(sortedModules[2] as? TestModule3)
        let testModule20 = try XCTUnwrap(sortedModules[3] as? TestModule2)
        let testModule21 = try XCTUnwrap(sortedModules[4] as? TestModule2)
        
        XCTAssert(testModule4.testModule5 === testModule5)
        
        XCTAssert(testModule20 !== testModule21)
        
        XCTAssert(testModule20.testModule3 === testModule3)
        XCTAssert(testModule21.testModule3 === testModule3)
        XCTAssert(testModule20.testModule4 === testModule4)
        XCTAssert(testModule21.testModule4 === testModule4)
        XCTAssert(testModule20.testModule5 === testModule5)
        XCTAssert(testModule21.testModule5 === testModule5)
        
        XCTAssert(testModule20.testModule4.testModule5 === testModule5)
        XCTAssert(testModule21.testModule4.testModule5 === testModule5)
    }


    func testModuleNoDependency() throws {
        let modules: [any Module] = [TestModule5()]
        let sortedModules = DependencyManager.resolve(modules)

        XCTAssertEqual(sortedModules.count, 1)

        _ = try XCTUnwrap(sortedModules[0] as? TestModule5)
    }

    func testModuleNoDependencyMultipleTimes() throws {
        let modules: [any Module] = [
            TestModule5(),
            TestModule5(),
            TestModule5()
        ]
        let sortedModules = DependencyManager.resolve(modules)

        XCTAssertEqual(sortedModules.count, 3)

        _ = try XCTUnwrap(sortedModules[0] as? TestModule5)
        _ = try XCTUnwrap(sortedModules[1] as? TestModule5)
        _ = try XCTUnwrap(sortedModules[2] as? TestModule5)
    }

    func testModuleCycle() throws {
        let modules: [any Module] = [
            TestModuleCircle1()
        ]

        try XCTRuntimePrecondition {
            _ = DependencyManager.resolve(modules)
        }
    }
}
