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
        secondTestExpection: XCTestExpectation,
        ifTestExpection: XCTestExpectation,
        elseTestExpection: XCTestExpectation
    ) -> Configuration {
        @ConfigurationBuilder
        var configuration: Configuration {
            TestConfiguration(expectation: firstTestExpection)
            if condition {
                TestConfiguration(expectation: secondTestExpection)
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
        let secondTestExpection = XCTestExpectation(description: "SecondTestConfiguration")
        secondTestExpection.assertForOverFulfill = true
        let ifTestExpection = XCTestExpectation(description: "IfTestConfiguration")
        ifTestExpection.assertForOverFulfill = true
        let elseTestExpection = XCTestExpectation(description: "ElseTestConfiguration")
        elseTestExpection.isInverted = true
        
        let configuration = configuration(
            condition: true,
            firstTestExpection: firstTestExpection,
            secondTestExpection: secondTestExpection,
            ifTestExpection: ifTestExpection,
            elseTestExpection: elseTestExpection
        )
        
        _ = CardinalKit(configuration: configuration)
        wait(for: [firstTestExpection, secondTestExpection, ifTestExpection, elseTestExpection], timeout: 0.1)
    }
    
    func testConfigurationBuilderElse() async {
        let firstTestExpection = XCTestExpectation(description: "FirstTestConfiguration")
        firstTestExpection.assertForOverFulfill = true
        let secondTestExpection = XCTestExpectation(description: "SecondTestConfiguration")
        secondTestExpection.isInverted = true
        let ifTestExpection = XCTestExpectation(description: "IfTestConfiguration")
        ifTestExpection.isInverted = true
        let elseTestExpection = XCTestExpectation(description: "ElseTestConfiguration")
        elseTestExpection.assertForOverFulfill = true
        
        let configuration = configuration(
            condition: false,
            firstTestExpection: firstTestExpection,
            secondTestExpection: secondTestExpection,
            ifTestExpection: ifTestExpection,
            elseTestExpection: elseTestExpection
        )
        
        _ = CardinalKit(configuration: configuration)
        wait(for: [firstTestExpection, secondTestExpection, ifTestExpection, elseTestExpection], timeout: 0.1)
    }
}
