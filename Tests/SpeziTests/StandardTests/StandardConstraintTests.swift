//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@_spi(APISupport) import SpeziCore
@testable import Spezi
import Testing

private protocol ExampleConstraint: Standard {
    func betterFulfill(expectation: TestExpectation)
}

@MainActor
@Suite
struct StandardConstraintTests {
    final class StandardCTestModule: Module {
        @StandardActor private var standard: any ExampleConstraint
        
        let expectation: TestExpectation
        
        
        init(expectation: TestExpectation) {
            self.expectation = expectation
        }
        
        
        func configure() {
            Task {
                await standard.betterFulfill(expectation: expectation)
            }
        }
    }
    
    class StandardCTestApplicationDelegate: SpeziAppDelegate {
        let expectation: TestExpectation
        
        
        override var configuration: Configuration {
            Configuration(standard: MockStandard()) {
                StandardCTestModule(expectation: expectation)
            }
        }
        
        
        init(expectation: TestExpectation) {
            self.expectation = expectation
        }
    }
    
    @Test
    func standardConstraint() async {
        let expectation = TestExpectation()
        
        let standardCTestApplicationDelegate = StandardCTestApplicationDelegate(
            expectation: expectation
        )
        _ = standardCTestApplicationDelegate.spezi
        
        await expectation.fulfillment(within: .seconds(0.5))
    }
}


extension MockStandard: ExampleConstraint {
    func betterFulfill(expectation: TestExpectation) {
        fulfill(expectation: expectation)
    }
}
