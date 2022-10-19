//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import XCTest


final class ConfigurationBuilderTests: XCTestCase {
    private func configuration(
        condition: Bool,
        firstTestExpection: XCTestExpectation,
        loopTestExpection: XCTestExpectation,
        conditionalTestExpection: XCTestExpectation,
        ifTestExpection: XCTestExpectation,
        elseTestExpection: XCTestExpectation
    ) -> AnyConfiguration {
        @ConfigurationBuilder<MockStandard>
        var configuration: AnyConfiguration {
            TestConfiguration(expectation: firstTestExpection)
            for _ in 0..<5 {
                TestConfiguration(expectation: loopTestExpection)
            }
            if condition {
                TestConfiguration(expectation: conditionalTestExpection)
            }
            if condition {
                TestConfiguration(expectation: ifTestExpection)
            } else {
                TestConfiguration(expectation: elseTestExpection)
            }
        }
        return configuration
    }
    
    
    func testConfigurationBuilderIf() async {
        let firstTestExpection = XCTestExpectation(description: "FirstTestConfiguration")
        firstTestExpection.assertForOverFulfill = true
        let loopTestExpection = XCTestExpectation(description: "LoopTestConfiguration")
        loopTestExpection.expectedFulfillmentCount = 5
        loopTestExpection.assertForOverFulfill = true
        let conditionalTestExpection = XCTestExpectation(description: "ConditionalTestConfiguration")
        conditionalTestExpection.assertForOverFulfill = true
        let ifTestExpection = XCTestExpectation(description: "IfTestConfiguration")
        ifTestExpection.assertForOverFulfill = true
        let elseTestExpection = XCTestExpectation(description: "ElseTestConfiguration")
        elseTestExpection.isInverted = true
        
        let configuration = configuration(
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
    
    func testConfigurationBuilderElse() async {
        let firstTestExpection = XCTestExpectation(description: "FirstTestConfiguration")
        firstTestExpection.assertForOverFulfill = true
        let loopTestExpection = XCTestExpectation(description: "LoopTestConfiguration")
        loopTestExpection.expectedFulfillmentCount = 5
        loopTestExpection.assertForOverFulfill = true
        let conditionalTestExpection = XCTestExpectation(description: "ConditionalTestConfiguration")
        conditionalTestExpection.isInverted = true
        let ifTestExpection = XCTestExpectation(description: "IfTestConfiguration")
        ifTestExpection.isInverted = true
        let elseTestExpection = XCTestExpectation(description: "ElseTestConfiguration")
        elseTestExpection.assertForOverFulfill = true
        
        let configuration = configuration(
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
