//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import CardinalKit
import XCTest


final class CardinalKitTests: XCTestCase {
    func testExample() async throws {
        let cardinalKit = CardinalKit()
        
        let firstGreeting = try await cardinalKit.greet()
        XCTAssertEqual(firstGreeting, "Hello, CardinalKit!")
        
        let secondGreeting = try await cardinalKit.greet("Paul")
        XCTAssertEqual(secondGreeting, "Hello, Paul!")
    }
}
