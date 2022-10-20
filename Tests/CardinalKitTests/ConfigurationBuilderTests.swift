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
            ifTestExpection: ifTestExpection,
            elseTestExpection: elseTestExpection
        )
        
        _ = CardinalKit<MockStandard>(configuration: configuration)
        wait(for: [firstTestExpection, loopTestExpection, conditionalTestExpection, ifTestExpection, elseTestExpection], timeout: 0.01)
    }
    
    func testComponentBuilderElse() async {
        let firstTestExpection = XCTestExpectation(description: "FirstTestComponent")
        firstTestExpection.assertForOverFulfill = true
        let loopTestExpection = XCTestExpectation(description: "LoopTestComponent")
        loopTestExpection.expectedFulfillmentCount = 5
        loopTestExpection.assertForOverFulfill = true
        let conditionalTestExpection = XCTestExpectation(description: "ConditionalTestComponent")
        conditionalTestExpection.isInverted = true
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
            ifTestExpection: ifTestExpection,
            elseTestExpection: elseTestExpection
        )
        
        _ = CardinalKit<MockStandard>(configuration: configuration)
        wait(for: [firstTestExpection, loopTestExpection, conditionalTestExpection, ifTestExpection, elseTestExpection], timeout: 0.01)
    }
}
