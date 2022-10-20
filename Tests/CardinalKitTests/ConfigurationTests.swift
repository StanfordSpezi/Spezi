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


final class ComponentTests: XCTestCase {
    class TestApplicationDelegate: CardinalKitAppDelegate {
        override var configuration: Configuration {
            Configuration(standard: MockStandard()) {
                TestComponent(expectation: configurationExpecation)
            }
        }
    }
    
    
    private static let configurationExpecation: XCTestExpectation = {
        let expectation = XCTestExpectation(description: "Component")
        expectation.assertForOverFulfill = true
        return expectation
    }()
    
    
    func testComponentFlow() throws {
        _ = try XCTUnwrap(
            Text("CardinalKit")
                .cardinalKit(TestApplicationDelegate()) as? ModifiedContent<Text, CardinalKitViewModifier>
        )
        wait(for: [ComponentTests.configurationExpecation], timeout: 0.1)
    }
    
    func testWrongComponentType() throws {
        struct SomeOtherStandard: Standard {}
        
        let expectation = XCTestExpectation(description: "Should not call configure method.")
        expectation.isInverted = true
        
        let testComponent = TestComponent<SomeOtherStandard>(expectation: expectation)
        _ = CardinalKit<MockStandard>(configuration: testComponent)
        
        wait(for: [expectation], timeout: 0.01)
    }
}
