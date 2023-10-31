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


final class StandardInjectionTests: XCTestCase {
    final class StandardInjectionTestModule: Module {
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
    
    class StandardInjectionTestApplicationDelegate: SpeziAppDelegate {
        let expectation: XCTestExpectation
        
        
        override var configuration: Configuration {
            Configuration(standard: MockStandard()) {
                StandardInjectionTestModule(expectation: expectation)
            }
        }
        
        
        init(expectation: XCTestExpectation) {
            self.expectation = expectation
        }
    }
    
    
    func testModuleFlow() async throws {
        let expectation = XCTestExpectation(description: "Module")
        expectation.assertForOverFulfill = true
        
        let standardInjectionTestApplicationDelegate = await StandardInjectionTestApplicationDelegate(
            expectation: expectation
        )
        _ = await standardInjectionTestApplicationDelegate.spezi
        
        await fulfillment(of: [expectation], timeout: 0.01)
    }
    
    func testInjectionPrecondition() throws {
        try XCTRuntimePrecondition {
            _ = _StandardPropertyWrapper<MockStandard>().wrappedValue
        }
    }
}
