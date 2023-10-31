//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi


extension DependencyManager {
    static func resolve(_ modules: [any Module]) -> [any Module] {
        let dependencyManager = DependencyManager(modules)
        dependencyManager.resolve()
        return dependencyManager.sortedModules
    }
}
