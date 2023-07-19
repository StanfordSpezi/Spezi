//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

/// Provides the ``KnowledgeSource`` for any value we store in the ``SpeziStorage`` that is
/// provided or request from am ``Component``.
///
/// For more information, look at the ``Component/Provide`` or ``Component/Collect`` property wrappers.
struct CollectedComponentValue<ComponentValue>: DefaultProvidingKnowledgeSource {
    typealias Anchor = SpeziAnchor

    typealias Value = [ComponentValue]


    static var defaultValue: [ComponentValue] {
        []
    }


    static func reduce(value: inout [ComponentValue], nextValue: [ComponentValue]) {
        value.append(contentsOf: nextValue)
    }
}
