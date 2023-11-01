//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import SwiftUI
import XCTest
import XCTRuntimeAssertions


final class ViewModifierTests: XCTestCase {
    func testViewModifierRetrieval() throws {
        let expectation = XCTestExpectation(description: "Module")
        expectation.assertForOverFulfill = true

        let testApplicationDelegate = TestApplicationDelegate(expectation: expectation)

        let modifiers = testApplicationDelegate.spezi.viewModifiers
        XCTAssertEqual(modifiers.count, 2)

        let message = modifiers
            .compactMap { $0 as? TestViewModifier }
            .map { $0.message }
            .joined(separator: " ")
        XCTAssertEqual(message, "Hello World")
    }
    
    func testEmptyRetrieval() {
        let speziAppDelegate = SpeziAppDelegate()
        XCTAssert(speziAppDelegate.spezi.viewModifiers.isEmpty)
    }
}
