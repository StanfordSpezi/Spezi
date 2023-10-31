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


final class StandardConstraintTests: XCTestCase {
    final class StandardCTestModule: Module {
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
    
    class StandardCTestApplicationDelegate: SpeziAppDelegate {
        let expectation: XCTestExpectation
        
        
        override var configuration: Configuration {
            Configuration(standard: MockStandard()) {
                StandardCTestModule(expectation: expectation)
            }
        }
        
        
        init(expectation: XCTestExpectation) {
            self.expectation = expectation
        }
    }
    
    
    func testStandardConstraint() async throws {
        let expectation = XCTestExpectation(description: "Module")
        expectation.assertForOverFulfill = true
        
        let standardCTestApplicationDelegate = await StandardCTestApplicationDelegate(
            expectation: expectation
        )
        _ = await standardCTestApplicationDelegate.spezi
        
        await fulfillment(of: [expectation], timeout: 0.01)
    }
}


extension MockStandard: ExampleConstraint {
    func betterFulfill(expectation: XCTestExpectation) {
        fulfill(expectation: expectation)
    }
}
