//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation


struct ImplicitlyCreatedModulesKey: DefaultProvidingKnowledgeSource {
    typealias Value = Set<ModuleReference>
    typealias Anchor = SpeziAnchor

    static let defaultValue: Value = []
}
