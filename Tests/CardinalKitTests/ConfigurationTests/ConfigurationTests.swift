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


final class ComponentTests: XCTestCase {
    func testComponentFlow() throws {
        let expectation = XCTestExpectation(description: "Component")
        expectation.assertForOverFulfill = true
        
        _ = try XCTUnwrap(
            Text("CardinalKit")
                .cardinalKit(TestApplicationDelegate(expectation: expectation)) as? ModifiedContent<Text, CardinalKitViewModifier>
        )
        wait(for: [expectation])
    }
}
