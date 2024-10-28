//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi
import XCTest


extension DependencyManager {
    static func resolve(_ modules: [any Module]) throws -> [any Module] {
        let dependencyManager = DependencyManager(modules)
        try dependencyManager.resolve()
        return dependencyManager.initializedModules
    }

    static func resolveWithoutErrors(_ modules: [any Module], file: StaticString = #filePath, line: UInt = #line) -> [any Module] {
        let dependencyManager = DependencyManager(modules)
        XCTAssertNoThrow(try dependencyManager.resolve(), file: file, line: line)
        return dependencyManager.initializedModules
    }
}
