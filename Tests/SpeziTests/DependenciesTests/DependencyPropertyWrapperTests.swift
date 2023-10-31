//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import XCTRuntimeAssertions


final class DependencyDescriptorTests: XCTestCase {
    func testInjectionPreconditionDependencyPropertyWrapper() throws {
        try XCTRuntimePrecondition {
            _ = _DependencyPropertyWrapper<TestModule>(wrappedValue: TestModule()).wrappedValue
        }
    }
    
    func testInjectionPreconditionDynamicDependenciesPropertyWrapper() throws {
        try XCTRuntimePrecondition {
            _ = _DynamicDependenciesPropertyWrapper(
                moduleProperties: [
                    _DependencyPropertyWrapper(wrappedValue: TestModule())
                ]
            ).wrappedValue
        }
    }
}
