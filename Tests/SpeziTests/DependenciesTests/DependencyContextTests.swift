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

@Suite(.serialized)
struct DependencyContextTests {
    @Test
    func injectionPreconditionDependencyPropertyWrapper() throws {
        expectRuntimePrecondition {
            _ = _DependencyPropertyWrapper<TestModule>(wrappedValue: TestModule(), TestModule.self).wrappedValue
        }
    }
    
    @Test
    func injectionPreconditionDynamicDependenciesPropertyWrapper() throws {
        expectRuntimePrecondition {
            _ = _DependencyPropertyWrapper {
                ExampleModule()
            }.wrappedValue
        }
    }
}
