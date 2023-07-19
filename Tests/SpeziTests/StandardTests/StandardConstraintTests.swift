//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import SwiftUI
import XCTest
import XCTRuntimeAssertions


private protocol ExampleConstraint: Standard {
    func betterFulfill(expectation: XCTestExpectation)
}


extension MockStandard: ExampleConstraint {
    func betterFulfill(expectation: XCTestExpectation) {
        fulfill(expectation: expectation)
    }
}


final class StandardConstraintTests: XCTestCase {
    final class StandardConstraintTestComponent: Component {
        @StandardActor private var standard: any ExampleConstraint
        
        let expectation: XCTestExpectation
        
        
        init(expectation: XCTestExpectation) {
            self.expectation = expectation
        }
        
        
        func configure() {
            Task {
                await standard.betterFulfill(expectation: expectation)
            }
        }
    }
    
    class StandardConstraintTestApplicationDelegate: SpeziAppDelegate {
        let expectation: XCTestExpectation
        
        
        override var configuration: Configuration {
            Configuration(standard: MockStandard()) {
                StandardConstraintTestComponent(expectation: expectation)
            }
        }
        
        
        init(expectation: XCTestExpectation) {
            self.expectation = expectation
        }
    }
    
    
    func testStandardConstraint() async throws {
        let expectation = XCTestExpectation(description: "Component")
        expectation.assertForOverFulfill = true
        
        let standardConstraintTestApplicationDelegate = await StandardConstraintTestApplicationDelegate(
            expectation: expectation
        )
        _ = await standardConstraintTestApplicationDelegate.spezi
        
        await fulfillment(of: [expectation], timeout: 0.01)
    }
}
