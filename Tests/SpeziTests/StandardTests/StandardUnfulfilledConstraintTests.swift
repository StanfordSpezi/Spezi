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


private protocol UnfulfilledExampleConstraint: Standard {
    func thisFunctionWouldBeNice()
}


final class StandardUnfulfilledConstraintTests: XCTestCase {
    final class StandardUCTestModule: Module {
        @StandardActor private var standard: any UnfulfilledExampleConstraint
        
        
        func configure() {
            Task {
                await standard.thisFunctionWouldBeNice()
            }
        }
    }
    
    class StandardUCTestApplicationDelegate: SpeziAppDelegate {
        override var configuration: Configuration {
            Configuration(standard: MockStandard()) {
                StandardUCTestModule()
            }
        }
    }
    
    
    @MainActor
    func testStandardUnfulfilledConstraint() throws {
        let standardCUTestApplicationDelegate = StandardUCTestApplicationDelegate()
        try XCTRuntimePrecondition(timeout: 0.5) {
            _ = standardCUTestApplicationDelegate.spezi
        }
    }
}
