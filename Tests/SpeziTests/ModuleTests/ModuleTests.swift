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


final class ModuleTests: XCTestCase {
    func testModuleFlow() throws {
        let expectation = XCTestExpectation(description: "Module")
        expectation.assertForOverFulfill = true
        
        _ = try XCTUnwrap(
            Text("Spezi")
                .spezi(TestApplicationDelegate(expectation: expectation)) as? ModifiedContent<Text, SpeziViewModifier>
        )
        wait(for: [expectation])
    }
}
