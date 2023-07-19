//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import Spezi

extension DependencyManager where S == MockStandard {
    static func resolve(_ components: [any Component<MockStandard>]) -> [any Component<MockStandard>] {
        let dependencyManager = DependencyManager(components)
        dependencyManager.resolve()
        return dependencyManager.sortedComponents
    }
}
