//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import XCTest
import XCTRuntimeAssertions


final class ComponentBuilderTests: XCTestCase {
    private struct Expectations {
        weak var xctestCase: XCTestCase?
        var firstTestExpection = Expectations.expecation(named: "FirstTestComponent")
        var loopTestExpection = Expectations.expecation(named: "LoopTestComponent")
        var conditionalTestExpection = Expectations.expecation(named: "ConditionalTestComponent")
        var availableConditionalTestExpection = Expectations.expecation(named: "AvailableConditionalTestExpection")
        var ifTestExpection = Expectations.expecation(named: "IfTestComponent")
        var elseTestExpection = Expectations.expecation(named: "FirstTestComponent")
        
        
        init(xctestCase: XCTestCase) {
            self.xctestCase = xctestCase
        }
        
        
        private static func expecation(named: String) -> XCTestExpectation {
            let expecation = XCTestExpectation(description: "FirstTestComponent")
            expecation.assertForOverFulfill = true
            return expecation
        }
        
        func wait() throws {
            guard let xctestCase else {
                XCTFail("Weak reference to `XCTestCase` was disassembled.")
                return
            }
            
            xctestCase.wait(
                for: [
                    firstTestExpection,
                    loopTestExpection,
                    conditionalTestExpection,
                    availableConditionalTestExpection,
                    ifTestExpection,
                    elseTestExpection
                ]
            )
        }
    }
    
    
    private func components(loopLimit: Int, condition: Bool, expecations: Expectations) -> ComponentCollection<MockStandard> {
        @ComponentBuilder<MockStandard>
        var components: ComponentCollection<MockStandard> {
            TestComponent(expectation: expecations.firstTestExpection)
            for _ in 0..<loopLimit {
                TestComponent(expectation: expecations.loopTestExpection)
            }
            if condition {
                TestComponent(expectation: expecations.conditionalTestExpection)
            }
            // The `#available(iOS 16, *)` mark is used to test `#available` in a result builder.
            // The availability check is not part of any part of the CardinalKit API.
            if #available(iOS 16, *) { // swiftlint:disable:this deployment_target
                TestComponent<MockStandard>(expectation: expecations.availableConditionalTestExpection)
            }
            if condition {
                TestComponent(expectation: expecations.ifTestExpection)
            } else {
                TestComponent(expectation: expecations.elseTestExpection)
            }
        }
        return components
    }
    
    
    func testComponentBuilderIf() throws {
        let expecations = Expectations(xctestCase: self)
        expecations.loopTestExpection.expectedFulfillmentCount = 5
        expecations.elseTestExpection.isInverted = true
        
        let components = components(
            loopLimit: 5,
            condition: true,
            expecations: expecations
        )
        
        _ = CardinalKit<MockStandard>(standard: MockStandard(), components: components.elements)
        try expecations.wait()
    }
    
    func testComponentBuilderElse() throws {
        let expecations = Expectations(xctestCase: self)
        expecations.conditionalTestExpection.isInverted = true
        expecations.loopTestExpection.expectedFulfillmentCount = 3
        expecations.ifTestExpection.isInverted = true
        
        let components = components(
            loopLimit: 3,
            condition: false,
            expecations: expecations
        )
        
        _ = CardinalKit<MockStandard>(standard: MockStandard(), components: components.elements)
        try expecations.wait()
    }
}
