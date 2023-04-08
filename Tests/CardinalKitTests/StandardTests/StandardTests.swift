//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import SwiftUI
import XCTest
import XCTRuntimeAssertions


final class StandardTests: XCTestCase {
    final class StandardInjectionTestComponent: Component {
        typealias ComponentStandard = MockStandard
        
        
        @StandardActor var standard: MockStandard
        let expectation: XCTestExpectation
        
        
        init(expectation: XCTestExpectation) {
            self.expectation = expectation
        }
        
        
        func configure() {
            Task {
                await standard.fulfill(expectation: expectation)
            }
        }
    }
    
    class StandardInjectionTestApplicationDelegate: CardinalKitAppDelegate {
        let expectation: XCTestExpectation
        
        
        override var configuration: Configuration {
            Configuration(standard: MockStandard()) {
                StandardInjectionTestComponent(expectation: expectation)
            }
        }
        
        
        init(expectation: XCTestExpectation) {
            self.expectation = expectation
        }
    }
    
    
    func testComponentFlow() async throws {
        let expectation = XCTestExpectation(description: "Component")
        expectation.assertForOverFulfill = true
        
        let standardInjectionTestApplicationDelegate = await StandardInjectionTestApplicationDelegate(
            expectation: expectation
        )
        _ = await standardInjectionTestApplicationDelegate.cardinalKit
        
        await fulfillment(of: [expectation], timeout: 0.01)
    }
    
    func testInjectionPrecondition() throws {
        try XCTRuntimePrecondition {
            _ = _StandardPropertyWrapper<MockStandard>().wrappedValue
        }
    }
}
