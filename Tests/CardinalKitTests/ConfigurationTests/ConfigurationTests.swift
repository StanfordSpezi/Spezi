//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
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
    
    func testWrongComponentType() throws {
        struct SomeOtherStandard: Standard {}
        
        let expectation = XCTestExpectation(description: "Should not call configure method.")
        expectation.isInverted = true
        
        let testComponent = TestComponent<SomeOtherStandard>(expectation: expectation)
        _ = CardinalKit<MockStandard>(components: [testComponent])
        
        wait(for: [expectation])
    }
}
