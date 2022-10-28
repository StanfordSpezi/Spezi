//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
@testable import XCTRuntimeAssertions


final class XCTRuntimeAssertionsTests: XCTestCase {
    func testXCTRuntimeAssertion() throws {
        let messages = [
            "assertionFailure()",
            "assert(false)",
            "assert(42 == 42)"
        ]
        var collectedMessages: [String] = []
        let number = 42
        
        try XCTRuntimeAssertion(
            validateRuntimeAssertion: {
                collectedMessages.append($0)
            },
            expectedFulfillmentCount: 3,
            "testXCTRuntimeAssertion"
        ) {
            assertionFailure(messages[0])
            assert(true, messages[1])
            assert(number == 42, messages[2])
        }
        
        XCTAssertEqual(messages, collectedMessages)
        
        try XCTRuntimeAssertion(validateRuntimeAssertion: { XCTAssertEqual($0, "") }) {
            assertionFailure()
        }
        
        try XCTRuntimeAssertion {
            assertionFailure()
        }
    }
    
    func testXCTRuntimePrecondition() throws {
        let number = 42
        
        try XCTRuntimePrecondition(
            validateRuntimeAssertion: {
                XCTAssertEqual("preconditionFailure()", $0)
            },
            "testXCTRuntimePrecondition"
        ) {
            precondition(number == 42, "preconditionFailure()")
        }
        
        try XCTRuntimePrecondition(validateRuntimeAssertion: { XCTAssertEqual($0, "") }) {
            preconditionFailure()
        }
        
        try XCTRuntimePrecondition {
            preconditionFailure()
        }
    }
}
