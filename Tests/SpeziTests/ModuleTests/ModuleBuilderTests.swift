//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import XCTest
import XCTRuntimeAssertions


final class ModuleBuilderTests: XCTestCase {
    private struct Expectations {
        weak var xctestCase: XCTestCase?
        var firstTestExpectation = Expectations.expectation(named: "FirstTestModule")
        var loopTestExpectation = Expectations.expectation(named: "LoopTestModule")
        var conditionalTestExpectation = Expectations.expectation(named: "ConditionalTestModule")
        var availableConditionalTestExpectation = Expectations.expectation(named: "AvailableConditionalTestExpection")
        var ifTestExpectation = Expectations.expectation(named: "IfTestModule")
        var elseTestExpectation = Expectations.expectation(named: "FirstTestModule")
        
        
        init(xctestCase: XCTestCase) {
            self.xctestCase = xctestCase
        }
        
        
        private static func expectation(named: String) -> XCTestExpectation {
            let expectation = XCTestExpectation(description: "FirstTestModule")
            expectation.assertForOverFulfill = true
            return expectation
        }
        
        func wait() throws {
            guard let xctestCase else {
                XCTFail("Weak reference to `XCTestCase` was disassembled.")
                return
            }
            
            xctestCase.wait(
                for: [
                    firstTestExpectation,
                    loopTestExpectation,
                    conditionalTestExpectation,
                    availableConditionalTestExpectation,
                    ifTestExpectation,
                    elseTestExpectation
                ]
            )
        }
    }
    
    
    private func modules(loopLimit: Int, condition: Bool, expectations: Expectations) -> ModuleCollection {
        @ModuleBuilder
        var modules: ModuleCollection {
            TestModule(expectation: expectations.firstTestExpectation)
            for _ in 0..<loopLimit {
                TestModule(expectation: expectations.loopTestExpectation)
            }
            if condition {
                TestModule(expectation: expectations.conditionalTestExpectation)
            }
            // The `#available(iOS 16, *)` mark is used to test `#available` in a result builder.
            // The availability check is not part of any part of the Spezi API.
            if #available(iOS 16, *) { // swiftlint:disable:this deployment_target
                TestModule(expectation: expectations.availableConditionalTestExpectation)
            }
            if condition {
                TestModule(expectation: expectations.ifTestExpectation)
            } else {
                TestModule(expectation: expectations.elseTestExpectation)
            }
        }
        return modules
    }
    
    
    func testModuleBuilderIf() throws {
        let expectations = Expectations(xctestCase: self)
        expectations.loopTestExpectation.expectedFulfillmentCount = 5
        expectations.elseTestExpectation.isInverted = true
        
        let modules = modules(
            loopLimit: 5,
            condition: true,
            expectations: expectations
        )
        
        _ = Spezi(standard: MockStandard(), modules: modules.elements)
        try expectations.wait()
    }
    
    func testModuleBuilderElse() throws {
        let expectations = Expectations(xctestCase: self)
        expectations.conditionalTestExpectation.isInverted = true
        expectations.loopTestExpectation.expectedFulfillmentCount = 3
        expectations.ifTestExpectation.isInverted = true
        
        let modules = modules(
            loopLimit: 3,
            condition: false,
            expectations: expectations
        )
        
        _ = Spezi(standard: MockStandard(), modules: modules.elements)
        try expectations.wait()
    }
}
