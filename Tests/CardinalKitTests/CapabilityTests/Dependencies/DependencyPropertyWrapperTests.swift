//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import XCTRuntimeAssertions


final class DependencyInjectableTests: XCTestCase {
    func testInjectionPrecondition() throws {
        try XCTRuntimePrecondition {
            _ = _DependencyPropertyWrapper<TestComponent, MockStandard>(wrappedValue: TestComponent()).wrappedValue
        }
    }
}
