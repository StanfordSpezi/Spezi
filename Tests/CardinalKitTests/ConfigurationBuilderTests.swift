//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import XCTest


final class ComponentBuilderTests: XCTestCase {
    private func configuration( // swiftlint:disable:this function_parameter_count
        loopLimit: Int,
        condition: Bool,
        firstTestExpection: XCTestExpectation,
        loopTestExpection: XCTestExpectation,
        conditionalTestExpection: XCTestExpectation,
        availableConditionalTestExpection: XCTestExpectation,
        ifTestExpection: XCTestExpectation,
        elseTestExpection: XCTestExpectation
    ) -> _AnyComponent {
        @ComponentBuilder<MockStandard>
        var configuration: _AnyComponent {
            TestComponent(expectation: firstTestExpection)
            for _ in 0..<loopLimit {
                TestComponent(expectation: loopTestExpection)
            }
            if condition {
                TestComponent(expectation: conditionalTestExpection)
            }
            if #available(iOS 16, *) { // swiftlint:disable:this deployment_target
                TestComponent<MockStandard>(expectation: availableConditionalTestExpection)
            }
            if condition {
                TestComponent(expectation: ifTestExpection)
            } else {
                TestComponent(expectation: elseTestExpection)
            }
        }
        return configuration
    }
    
    
    func testComponentBuilderIf() async {
        let firstTestExpection = XCTestExpectation(description: "FirstTestComponent")
        firstTestExpection.assertForOverFulfill = true
        let loopTestExpection = XCTestExpectation(description: "LoopTestComponent")
        loopTestExpection.expectedFulfillmentCount = 5
        loopTestExpection.assertForOverFulfill = true
        let conditionalTestExpection = XCTestExpectation(description: "ConditionalTestComponent")
        conditionalTestExpection.assertForOverFulfill = true
        let availableConditionalTestExpection = XCTestExpectation(description: "AvailableConditionalTestExpection")
        availableConditionalTestExpection.assertForOverFulfill = true
        let ifTestExpection = XCTestExpectation(description: "IfTestComponent")
        ifTestExpection.assertForOverFulfill = true
        let elseTestExpection = XCTestExpectation(description: "ElseTestComponent")
        elseTestExpection.isInverted = true
        
        let configuration = configuration(
            loopLimit: 5,
            condition: true,
            firstTestExpection: firstTestExpection,
            loopTestExpection: loopTestExpection,
            conditionalTestExpection: conditionalTestExpection,
            availableConditionalTestExpection: availableConditionalTestExpection,
            ifTestExpection: ifTestExpection,
            elseTestExpection: elseTestExpection
        )
        
        _ = CardinalKit<MockStandard>(configuration: configuration)
        wait(
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
    
    func testComponentBuilderElse() async {
        let firstTestExpection = XCTestExpectation(description: "FirstTestComponent")
        firstTestExpection.assertForOverFulfill = true
        let loopTestExpection = XCTestExpectation(description: "LoopTestComponent")
        loopTestExpection.expectedFulfillmentCount = 5
        loopTestExpection.assertForOverFulfill = true
        let conditionalTestExpection = XCTestExpectation(description: "ConditionalTestComponent")
        conditionalTestExpection.isInverted = true
        let availableConditionalTestExpection = XCTestExpectation(description: "AvailableConditionalTestExpection")
        availableConditionalTestExpection.assertForOverFulfill = true
        let ifTestExpection = XCTestExpectation(description: "IfTestComponent")
        ifTestExpection.isInverted = true
        let elseTestExpection = XCTestExpectation(description: "ElseTestComponent")
        elseTestExpection.assertForOverFulfill = true
        
        let configuration = configuration(
            loopLimit: 5,
            condition: false,
            firstTestExpection: firstTestExpection,
            loopTestExpection: loopTestExpection,
            conditionalTestExpection: conditionalTestExpection,
            availableConditionalTestExpection: availableConditionalTestExpection,
            ifTestExpection: ifTestExpection,
            elseTestExpection: elseTestExpection
        )
        
        _ = CardinalKit<MockStandard>(configuration: configuration)
        wait(
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
