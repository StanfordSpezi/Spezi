//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import XCTRuntimeAssertions

private final class ExampleModule: Module {}

final class DependencyContextTests: XCTestCase {
    func testInjectionPreconditionDependencyPropertyWrapper() throws {
        try XCTRuntimePrecondition {
            _ = _DependencyPropertyWrapper<TestModule>(wrappedValue: TestModule()).wrappedValue
        }
    }
    
    func testInjectionPreconditionDynamicDependenciesPropertyWrapper() throws {
        try XCTRuntimePrecondition {
            _ = _DependencyPropertyWrapper {
                ExampleModule()
            }
                .wrappedValue
        }
    }
}
