//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import RuntimeAssertionsTesting
import Spezi
import Testing

private final class ExampleModule: Module {}

@Suite
struct DependencyContextTests {
    @Test(.disabled(if: ProcessInfo.isReleaseTest))
    func injectionPreconditionDependencyPropertyWrapper() throws {
        expectRuntimePrecondition {
            _ = _DependencyPropertyWrapper<TestModule>(wrappedValue: TestModule(), TestModule.self).wrappedValue
        }
    }
    
    @Test(.disabled(if: ProcessInfo.isReleaseTest))
    func injectionPreconditionDynamicDependenciesPropertyWrapper() throws {
        expectRuntimePrecondition {
            _ = _DependencyPropertyWrapper {
                ExampleModule()
            }.wrappedValue
        }
    }
}
