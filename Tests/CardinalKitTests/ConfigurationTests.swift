//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import SwiftUI
import XCTest


final class ConfigurationTests: XCTestCase {
    class TestApplicationDelegate: CardinalKitAppDelegate {
        override var configuration: CardinalKitConfiguration {
            CardinalKitConfiguration(standard: MockStandard()) {
                TestConfiguration(expectation: configurationExpecation)
            }
        }
    }
    
    
    private static let configurationExpecation: XCTestExpectation = {
        let expectation = XCTestExpectation(description: "Configuration")
        expectation.assertForOverFulfill = true
        return expectation
    }()
    
    
    func testConfigurationFlow() throws {
        _ = try XCTUnwrap(
            Text("CardinalKit")
                .cardinalKit(TestApplicationDelegate()) as? ModifiedContent<Text, CardinalKitViewModifier>
        )
        wait(for: [ConfigurationTests.configurationExpecation], timeout: 0.1)
    }
    
    func testWrongConfigurationType() throws {
        struct SomeOtherStandard: Standard {}
        
        let expectation = XCTestExpectation(description: "Should not call configure method.")
        expectation.isInverted = true
        
        let testConfiguration = TestConfiguration<SomeOtherStandard>(expectation: expectation)
        _ = CardinalKit<MockStandard>(configuration: testConfiguration)
        
        wait(for: [expectation], timeout: 0.01)
    }
}
