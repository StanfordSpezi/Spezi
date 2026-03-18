//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import RuntimeAssertionsTesting
import Spezi
import Testing

private final class ExampleModule: Module {}

@Suite
struct DependencyContextTests {
    // These tests verify that accessing a @Dependency before activation triggers a precondition failure.
    // On Linux Release builds, XCTRuntimeAssertions cannot intercept preconditionFailure() because
    // Swift Testing doesn't load XCTest, causing a real crash instead. Skip until upstream is fixed.
    static let isLinuxRelease: Bool = {
        #if os(Linux) && !DEBUG
        return true
        #else
        return false
        #endif
    }()

    @Test(.disabled(if: DependencyContextTests.isLinuxRelease, "expectRuntimePrecondition crashes on Linux Release (XCTRuntimeAssertions #...)"))
    func injectionPreconditionDependencyPropertyWrapper() throws {
        expectRuntimePrecondition {
            _ = _DependencyPropertyWrapper<TestModule>(wrappedValue: TestModule(), TestModule.self).wrappedValue
        }
    }

    @Test(.disabled(if: DependencyContextTests.isLinuxRelease, "expectRuntimePrecondition crashes on Linux Release (XCTRuntimeAssertions #...)"))
    func injectionPreconditionDynamicDependenciesPropertyWrapper() throws {
        expectRuntimePrecondition {
            _ = _DependencyPropertyWrapper {
                ExampleModule()
            }.wrappedValue
        }
    }
}
