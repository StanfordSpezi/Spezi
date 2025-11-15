//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import RuntimeAssertionsTesting
@testable import Spezi
@_spi(APISupport) import SpeziCore
import SwiftUI
import Testing

@Suite
struct StandardInjectionTests {
    final class StandardInjectionTestModule: Module {
        @StandardActor var standard: MockStandard
        
        let expectation: TestExpectation
        
        
        init(expectation: TestExpectation) {
            self.expectation = expectation
        }
        
        
        func configure() {
            Task {
                await standard.fulfill(expectation: expectation)
            }
        }
    }
    
    class StandardInjectionTestApplicationDelegate: SpeziAppDelegate {
        let expectation: TestExpectation
        
        
        override var configuration: Configuration {
            Configuration(standard: MockStandard()) {
                StandardInjectionTestModule(expectation: expectation)
            }
        }
        
        
        init(expectation: TestExpectation) {
            self.expectation = expectation
        }
    }
    
    @Test
    func moduleFlow() async throws {
        let expectation = TestExpectation()
        
        let standardInjectionTestApplicationDelegate = await StandardInjectionTestApplicationDelegate(
            expectation: expectation
        )
        _ = await standardInjectionTestApplicationDelegate.spezi
        
        await expectation.fulfillment(within: .seconds(0.5))
    }
    
    @Test
    func injectionPrecondition() throws {
        expectRuntimePrecondition {
            _ = _StandardPropertyWrapper<MockStandard>().wrappedValue
        }
    }
}
