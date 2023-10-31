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


final class ComponentBuilderTests: XCTestCase {
    private struct Expectations {
        weak var xctestCase: XCTestCase?
        var firstTestExpectation = Expectations.expectation(named: "FirstTestComponent")
        var loopTestExpectation = Expectations.expectation(named: "LoopTestComponent")
        var conditionalTestExpectation = Expectations.expectation(named: "ConditionalTestComponent")
        var availableConditionalTestExpectation = Expectations.expectation(named: "AvailableConditionalTestExpection")
        var ifTestExpectation = Expectations.expectation(named: "IfTestComponent")
        var elseTestExpectation = Expectations.expectation(named: "FirstTestComponent")
        
        
        init(xctestCase: XCTestCase) {
            self.xctestCase = xctestCase
        }
        
        
        private static func expectation(named: String) -> XCTestExpectation {
            let expectation = XCTestExpectation(description: "FirstTestComponent")
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
    
    
    private func components(loopLimit: Int, condition: Bool, expectations: Expectations) -> ComponentCollection {
        @ComponentBuilder
        var components: ComponentCollection {
            TestComponent(expectation: expectations.firstTestExpectation)
            for _ in 0..<loopLimit {
                TestComponent(expectation: expectations.loopTestExpectation)
            }
            if condition {
                TestComponent(expectation: expectations.conditionalTestExpectation)
            }
            // The `#available(iOS 16, *)` mark is used to test `#available` in a result builder.
            // The availability check is not part of any part of the Spezi API.
            if #available(iOS 16, *) { // swiftlint:disable:this deployment_target
                TestComponent(expectation: expectations.availableConditionalTestExpectation)
            }
            if condition {
                TestComponent(expectation: expectations.ifTestExpectation)
            } else {
                TestComponent(expectation: expectations.elseTestExpectation)
            }
        }
        return components
    }
    
    
    func testComponentBuilderIf() throws {
        let expectations = Expectations(xctestCase: self)
        expectations.loopTestExpectation.expectedFulfillmentCount = 5
        expectations.elseTestExpectation.isInverted = true
        
        let components = components(
            loopLimit: 5,
            condition: true,
            expectations: expectations
        )
        
        _ = Spezi(standard: MockStandard(), components: components.elements)
        try expectations.wait()
    }
    
    func testComponentBuilderElse() throws {
        let expectations = Expectations(xctestCase: self)
        expectations.conditionalTestExpectation.isInverted = true
        expectations.loopTestExpectation.expectedFulfillmentCount = 3
        expectations.ifTestExpectation.isInverted = true
        
        let components = components(
            loopLimit: 3,
            condition: false,
            expectations: expectations
        )
        
        _ = Spezi(standard: MockStandard(), components: components.elements)
        try expectations.wait()
    }
}
