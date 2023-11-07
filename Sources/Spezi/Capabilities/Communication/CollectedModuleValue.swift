//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFoundation


/// Provides the ``KnowledgeSource`` for any value we store in the ``SpeziStorage`` that is
/// provided or request from am ``Module``.
///
/// For more information, look at the ``Module/Provide`` or ``Module/Collect`` property wrappers.
struct CollectedModuleValue<ModuleValue>: DefaultProvidingKnowledgeSource {
    typealias Anchor = SpeziAnchor

    typealias Value = [ModuleValue]


    static var defaultValue: [ModuleValue] {
        []
    }


    static func reduce(value: inout [ModuleValue], nextValue: [ModuleValue]) {
        value.append(contentsOf: nextValue)
    }
}
